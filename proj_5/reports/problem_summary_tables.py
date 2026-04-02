import pandas as pd
import os
from analysis_utils import read_timing_csv, calculate_speedup, calculate_efficiency

# --- Configuration ---
DATA_DIR = 'reports/data'
REPORTS_DIR = 'reports'

# --- Helper to create markdown table ---
def create_markdown_table(df, title):
    md = f"### {title}\n\n"
    md += df.to_markdown(index=True)
    md += "\n\n"
    return md

# --- Process Problem 2 ---
def process_problem2():
    print("Processing Problem 2 data...")
    file_path = os.path.join(DATA_DIR, 'problem2_times.csv')
    try:
        df_p2_times = read_timing_csv(file_path)
        # Assuming the first column is an index (like 'student'), so set it as index
        df_p2_times = df_p2_times.set_index(df_p2_times.columns[0])
    except FileNotFoundError:
        print(f"Warning: {file_path} not found. Skipping Problem 2.")
        return

    # Calculate Speedup
    # Problem 2 columns are like P2-18-2th, P2-19-2th etc.
    # The calculate_speedup function handles problems prefixed with 'P' and 'th' suffix
    p2_speedup = calculate_speedup(df_p2_times, parallel_col_suffix='th')
    
    # Calculate Efficiency
    p2_efficiency = calculate_efficiency(p2_speedup, parallel_col_suffix='th')

    # Combine results for display in Markdown table
    # Extract only the timing columns for the initial table
    # Select columns that start with 'P2' and end with 'th'
    time_cols = [col for col in df_p2_times.columns if col.startswith('P2') and col.endswith('th')]
    p2_summary_df = df_p2_times[time_cols].copy()
    
    # Merge speedup and efficiency into the summary DataFrame
    # Need to align columns correctly
    for col in p2_speedup.columns:
        original_col = col.replace('_Speedup', '')
        p2_summary_df[f"{original_col}_Speedup"] = p2_speedup[col]

    for col in p2_efficiency.columns:
        original_col = col.replace('_Efficiency', '')
        p2_summary_df[f"{original_col}_Efficiency"] = p2_efficiency[col]

    # Save to Markdown
    md_table = create_markdown_table(p2_summary_df, "Problem 2: Parallel Dot Product Performance")
    with open(os.path.join(REPORTS_DIR, 'problem2_summary_table.md'), 'w') as f:
        f.write(md_table)
    print("Problem 2 summary table generated.")

# --- Process Problem 3 ---
def process_problem3():
    print("Processing Problem 3 data...")
    file_path = os.path.join(DATA_DIR, 'problem3_times.csv')
    try:
        df_p3_times = read_timing_csv(file_path)
        df_p3_times = df_p3_times.set_index(df_p3_times.columns[0])
    except FileNotFoundError:
        print(f"Warning: {file_path} not found. Skipping Problem 3.")
        return

    p3_speedup = calculate_speedup(df_p3_times, parallel_col_suffix='th')
    p3_efficiency = calculate_efficiency(p3_speedup, parallel_col_suffix='th')

    time_cols = [col for col in df_p3_times.columns if col.startswith('P3') and col.endswith('th')]
    p3_summary_df = df_p3_times[time_cols].copy()

    for col in p3_speedup.columns:
        original_col = col.replace('_Speedup', '')
        p3_summary_df[f"{original_col}_Speedup"] = p3_speedup[col]
    for col in p3_efficiency.columns:
        original_col = col.replace('_Efficiency', '')
        p3_summary_df[f"{original_col}_Efficiency"] = p3_efficiency[col]

    md_table = create_markdown_table(p3_summary_df, "Problem 3: Parallel Merge Sort Performance")
    with open(os.path.join(REPORTS_DIR, 'problem3_summary_table.md'), 'w') as f:
        f.write(md_table)
    print("Problem 3 summary table generated.")

# --- Process Problem 4 ---
def process_problem4():
    print("Processing Problem 4 data...")
    file_path = os.path.join(DATA_DIR, 'problem4_times.csv')
    try:
        df_p4_times = read_timing_csv(file_path)
        df_p4_times = df_p4_times.set_index(df_p4_times.columns[0])
    except FileNotFoundError:
        print(f"Warning: {file_path} not found. Skipping Problem 4.")
        return

    # Problem 4 columns are like P4-2th, P4-4th etc.
    p4_speedup = calculate_speedup(df_p4_times, parallel_col_suffix='th')
    p4_efficiency = calculate_efficiency(p4_speedup, parallel_col_suffix='th')

    time_cols = [col for col in df_p4_times.columns if col.startswith('P4') and col.endswith('th')]
    p4_summary_df = df_p4_times[time_cols].copy()

    for col in p4_speedup.columns:
        original_col = col.replace('_Speedup', '')
        p4_summary_df[f"{original_col}_Speedup"] = p4_speedup[col]
    for col in p4_efficiency.columns:
        original_col = col.replace('_Efficiency', '')
        p4_summary_df[f"{original_col}_Efficiency"] = p4_efficiency[col]

    md_table = create_markdown_table(p4_summary_df, "Problem 4: Monte Carlo Pi Performance")
    with open(os.path.join(REPORTS_DIR, 'problem4_summary_table.md'), 'w') as f:
        f.write(md_table)
    print("Problem 4 summary table generated.")

if __name__ == "__main__":
    os.makedirs(REPORTS_DIR, exist_ok=True) # Ensure reports directory exists
    process_problem2()
    process_problem3()
    process_problem4()