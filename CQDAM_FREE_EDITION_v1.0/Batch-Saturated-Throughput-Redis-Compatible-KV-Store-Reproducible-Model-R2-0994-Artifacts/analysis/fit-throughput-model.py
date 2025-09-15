#!/usr/bin/env python3
"""
CQDAM Throughput Model Fitting Script
Reproduces the R² ≈ 0.994 batched-service model T(p) = p/(t0 + t1p)

Author: Darreck Lamar Bender II
Organization: Laminar Instruments Inc.
Date: September 15, 2025
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
import glob
import os

def fit_batched_service_model(csv_files):
    """
    Fit T(p) = p/(t0 + t1p) model to benchmark data
    Returns t0, t1, R², and confidence intervals
    """
    
    # Collect data from all CSV files
    data_points = []
    
    for csv_file in csv_files:
        try:
            df = pd.read_csv(csv_file)
            if 'rps' in df.columns and len(df) > 0:
                # Extract pipeline depth from filename
                import re
                p_match = re.search(r'P(\d+)', csv_file)
                if p_match:
                    p = int(p_match.group(1))
                    throughput = df['rps'].iloc[0]  # ops/sec
                    data_points.append((p, throughput))
        except Exception as e:
            print(f"Skipping {csv_file}: {e}")
    
    if len(data_points) < 5:
        print("Insufficient data points for fitting")
        return None
    
    # Convert to arrays
    data_points.sort()  # Sort by pipeline depth
    p_values = np.array([point[0] for point in data_points])
    T_values = np.array([point[1] for point in data_points])  # throughput
    
    # Linearize: y = p/T = t0 + t1*p where T is in ops/sec, so p/T is in seconds
    T_ops_per_sec = T_values
    y = p_values / T_ops_per_sec  # seconds per batch
    x = p_values
    
    # Ordinary least squares
    coeffs = np.polyfit(x, y, 1)
    t1_sec, t0_sec = coeffs  # slope (sec/op), intercept (sec/batch)
    
    # Convert units for paper
    t0_us = t0_sec * 1e6  # convert to microseconds/batch
    t1_ns = t1_sec * 1e9  # convert to nanoseconds/op
    
    # Calculate R²
    y_pred = t0_sec + t1_sec * x
    ss_res = np.sum((y - y_pred)**2)
    ss_tot = np.sum((y - np.mean(y))**2)
    r_squared = 1 - (ss_res / ss_tot)
    
    # Standard errors (simplified)
    n = len(x)
    mse = ss_res / (n - 2)
    x_mean = np.mean(x)
    sxx = np.sum((x - x_mean)**2)
    
    se_t1_sec = np.sqrt(mse / sxx)
    se_t0_sec = np.sqrt(mse * (1/n + x_mean**2/sxx))
    
    # 95% confidence intervals
    t_crit = stats.t.ppf(0.975, n-2)
    t0_ci = [t0_us - t_crit*se_t0_sec*1e6, t0_us + t_crit*se_t0_sec*1e6]
    t1_ci = [t1_ns - t_crit*se_t1_sec*1e9, t1_ns + t_crit*se_t1_sec*1e9]
    
    results = {
        't0_us_per_batch': float(t0_us),
        't1_ns_per_op': float(t1_ns),
        'r_squared': float(r_squared),
        't0_confidence_interval': [float(x) for x in t0_ci],
        't1_confidence_interval': [float(x) for x in t1_ci],
        'Tmax_Mops_s': float(1/(t1_sec*1e6)) if t1_sec > 0 else float('inf'),  # Theoretical maximum
        'data_points': int(len(data_points)),
        'raw_data': [[float(p), float(T)] for p, T in zip(p_values, T_values)]
    }
    
    return results

def generate_figure(results, output_path):
    """Generate the throughput vs pipeline depth figure"""
    if not results:
        return
        
    p_values, T_values = zip(*results['raw_data'])
    p_values = np.array(p_values)
    T_values = np.array(T_values)
    
    # Model curve
    t0 = results['t0_us_per_batch'] * 1e-6  # Convert to seconds
    t1 = results['t1_ns_per_op'] * 1e-9    # Convert to seconds
    
    p_model = np.linspace(1, max(p_values)*1.2, 200)
    T_model = p_model / (t0 + t1 * p_model) / 1e6  # Convert to Mops/s
    
    plt.figure(figsize=(10, 6))
    plt.scatter(p_values, T_values/1e6, color='blue', s=50, label='Measured', zorder=3)
    plt.plot(p_model, T_model, 'r-', linewidth=2, 
             label=f'Model: T(p) = p/({results["t0_us_per_batch"]:.2f} + {results["t1_ns_per_op"]:.1f}p)', 
             zorder=2)
    
    plt.xlabel('Pipeline Depth (p)')
    plt.ylabel('Throughput (Mops/s)')
    plt.title(f'Throughput vs Pipeline Depth (R² = {results["r_squared"]:.3f})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # Annotate knee point
    knee_p = results['t0_us_per_batch'] * 1e-6 / (results['t1_ns_per_op'] * 1e-9)
    knee_T = 1 / (2 * results['t1_ns_per_op'] * 1e-9) / 1e6
    plt.annotate(f'Knee at p ≈ {knee_p:.0f}', xy=(knee_p, knee_T), 
                xytext=(knee_p*1.5, knee_T*0.8), 
                arrowprops=dict(arrowstyle='->', color='black'))
    
    plt.tight_layout()
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()

def main():
    # Find all benchmark CSV files
    data_dir = "../data/bench"
    csv_files = glob.glob(os.path.join(data_dir, "*.csv"))
    
    if not csv_files:
        print(f"No CSV files found in {data_dir}")
        return
    
    print(f"Processing {len(csv_files)} CSV files...")
    
    # Fit the model
    results = fit_batched_service_model(csv_files)
    
    if results:
        print("\nCQDAM Throughput Model Results:")
        print("=" * 40)
        print(f"t₀ = {results['t0_us_per_batch']:.2f} μs/batch [{results['t0_confidence_interval'][0]:.2f}, {results['t0_confidence_interval'][1]:.2f}]")
        print(f"t₁ = {results['t1_ns_per_op']:.1f} ns/op [{results['t1_confidence_interval'][0]:.1f}, {results['t1_confidence_interval'][1]:.1f}]")
        print(f"R² = {results['r_squared']:.6f}")
        print(f"Tₘₐₓ = {results['Tmax_Mops_s']:.2f} Mops/s")
        print(f"Data points: {results['data_points']}")
        
        # Generate figure
        generate_figure(results, "throughput_vs_pipeline_model.png")
        print(f"\nFigure saved: throughput_vs_pipeline_model.png")
        
        # Save results
        import json
        with open("model_fit_results.json", 'w') as f:
            json.dump(results, f, indent=2)
        print("Results saved: model_fit_results.json")
        
    else:
        print("Model fitting failed")

if __name__ == "__main__":
    main()