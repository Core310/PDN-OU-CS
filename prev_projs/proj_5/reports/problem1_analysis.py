import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from analysis_utils import read_timing_csv
import os

# --- Configuration ---
DATA_DIR = 'reports/data'
PLOTS_DIR = 'reports'

# Create plots directory if it doesn't exist
os.makedirs(PLOTS_DIR, exist_ok=True)

# --- Load Data ---
try:
    df_diffnode = read_timing_csv(os.path.join(DATA_DIR, 'problem1_times_diffnode.csv'))
    df_samenode = read_timing_csv(os.path.join(DATA_DIR, 'problem1_times_samenode.csv'))
except FileNotFoundError as e:
    print(f"Error loading data: {e}. Ensure dummy files are created or actual data is present.")
    exit(1)

# The CSVs are expected to have two columns: [identifier (e.g., filename), time]
# We need to extract the array size from the identifier
def extract_array_size(identifier):
    # Example identifier: "time_1M_diff.csv" -> 1000000
    # Example identifier: "time_8M_diff.csv" -> 8000000
    parts = identifier.split('_')
    if len(parts) >= 2:
        num_str = parts[1].replace('M', '000000') # Convert '1M' to '1000000'
        if num_str.endswith('.csv'):
            num_str = num_str[:-4] # Remove .csv
        try:
            return int(num_str)
        except ValueError:
            pass
    return 0 # Default if parsing fails

def process_dataframe(df, title_suffix, filename_suffix):
    # Ensure DataFrame has at least 2 columns
    if df.shape[1] < 2:
        print(f"Skipping {title_suffix}: DataFrame does not have enough columns for parsing.")
        return

    # Assuming the first column is the identifier and the second is the time
    df['array_size'] = df.iloc[:, 0].apply(extract_array_size)
    df['time'] = df.iloc[:, 1]
    
    # Filter out rows where array_size could not be extracted
    df = df[df['array_size'] > 0]
    
    if df.empty:
        print(f"No valid data to plot for {title_suffix}.")
        return

    # Sort by array_size for plotting
    df = df.sort_values(by='array_size')

    # Calculate one-way transmission time (total time / 2 / 1000 rounds)
    # The current pingpong_MPI code measures total round trip time for 1000 rounds
    # We need to divide by (2 * 1000) for one-way time per exchange
    df['one_way_time'] = df['time'] / (2 * 1000) # 2 for round trip, 1000 for iterations

    # Linear Regression (time = latency + (1/bandwidth) * message_size)
    # Message size in bytes = array_size * sizeof(int)
    # Assuming sizeof(int) = 4 bytes
    message_sizes_bytes = df['array_size'] * 4 
    
    # Reshape for numpy polyfit
    x = message_sizes_bytes.values.reshape(-1, 1)
    y = df['one_way_time'].values

    # Perform linear regression
    # np.polyfit returns coefficients [slope, intercept]
    try:
        slope, intercept = np.polyfit(x.flatten(), y, 1)
        latency = intercept
        # Bandwidth = 1 / slope (time = latency + message_size / bandwidth)
        # Note: slope is in (seconds/byte), so 1/slope is bytes/second
        bandwidth = 1 / slope if slope != 0 else float('inf') 
    except Exception as e:
        print(f"Error performing linear regression for {title_suffix}: {e}")
        latency = np.nan
        bandwidth = np.nan


    # Plotting
    plt.figure(figsize=(10, 6))
    plt.scatter(message_sizes_bytes, df['one_way_time'], label='Data Points')
    plt.plot(message_sizes_bytes, slope * message_sizes_bytes + intercept, color='red', label='Linear Fit')
    plt.title(f'Problem 1: Array Size vs. One-Way Transmission Time ({title_suffix})')
    plt.xlabel('Message Size (bytes)')
    plt.ylabel('One-Way Transmission Time (seconds)')
    plt.legend()
    plt.grid(True)
    plt.savefig(os.path.join(PLOTS_DIR, f'problem1_plot_{filename_suffix}.png'))
    plt.close()

    print(f"\n--- {title_suffix} Results ---")
    print(f"Estimated Latency: {latency:.8e} seconds")
    print(f"Estimated Bandwidth: {bandwidth:.2f} bytes/second")
    
# Process diffnode data
process_dataframe(df_diffnode.copy(), 'Different Nodes', 'diffnode')

# Process samenode data
process_dataframe(df_samenode.copy(), 'Same Node', 'samenode')

