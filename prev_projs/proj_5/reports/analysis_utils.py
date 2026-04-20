import pandas as pd

def read_timing_csv(file_path):
    """
    Reads a timing CSV file into a pandas DataFrame.
    Assumes the CSV has a header row.
    """
    return pd.read_csv(file_path)

def calculate_speedup(df, baseline_col_prefix='P_2th', parallel_col_suffix='th'):
    # print(f"DEBUG: calculate_speedup received df type: {type(df)}, df.index: {df.index}") # Removed initial debug print
    """
    Calculates speedup for different thread counts.
    Assumes column names are in the format 'P<problem>-<threads>th'.
    """
    speedup_df = pd.DataFrame(index=df.index)

    # Extract problem names from columns
    problem_names = sorted(list(set([col.split('-')[0] for col in df.columns])))

    for problem in problem_names:
        # Dynamically find the baseline column (e.g., the 2-thread column for each problem)
        baseline_cols = [col for col in df.columns if col.startswith(problem) and f"-2{parallel_col_suffix}" in col]

        if baseline_cols:
            # Assume the first matching 2-thread column is the baseline
            baseline_time = df[baseline_cols[0]].iloc[0] 

            for col in df.columns:
                if col.startswith(problem) and col.endswith(parallel_col_suffix):
                    # Extract number of threads for the current column
                    try:
                        num_threads_str = col.split('-')[1].replace(parallel_col_suffix, '')
                        num_threads = int(num_threads_str)
                    except (IndexError, ValueError):
                        num_threads = 0 # Fallback for malformed column names

                    if num_threads > 0: 
                        speedup_df[f"{col}_Speedup"] = baseline_time / df[col].iloc[0]
                    else:
                        speedup_df[f"{col}_Speedup"] = np.nan # Use NaN for invalid/zero threads
        else:
            print(f"Warning: No 2-thread baseline column found for problem {problem}. Skipping speedup calculation for this problem.")
    return speedup_df


def calculate_efficiency(df_speedup, parallel_col_suffix='th'):
    """
    Calculates efficiency from a DataFrame containing speedup values.
    Assumes column names are in the format 'P<problem>-<size>-<threads>th_Speedup' or 'P<problem>-<threads>th_Speedup'.
    """
    if df_speedup.empty:
        return pd.DataFrame() # Return empty if speedup_df is empty

    efficiency_df = pd.DataFrame(index=df_speedup.index)
    
    for col in df_speedup.columns:
        if col.endswith("_Speedup"):
            # Example cols: "P2-18-2th_Speedup", "P4-4th_Speedup"
            parts = col.split('-')
            num_processors_str = None
            
            # Handle format 'P#-size-#th_Speedup' (len=3) and 'P#-#th_Speedup' (len=2)
            if len(parts) == 3: 
                num_processors_str = parts[2].replace(f"{parallel_col_suffix}_Speedup", "")
            elif len(parts) == 2:
                num_processors_str = parts[1].replace(f"{parallel_col_suffix}_Speedup", "")

            if num_processors_str:
                try:
                    num_processors = int(num_processors_str)
                    if num_processors > 0:
                        efficiency_df[col.replace("_Speedup", "_Efficiency")] = df_speedup[col] / num_processors
                    else:
                        efficiency_df[col.replace("_Speedup", "_Efficiency")] = np.nan # Use NaN for 0 threads
                except ValueError:
                    print(f"Warning: Could not parse number of processors from column {col}. Skipping efficiency calculation.")
            else:
                print(f"Warning: Invalid speedup column format {col}. Skipping efficiency calculation.")

    return efficiency_df
