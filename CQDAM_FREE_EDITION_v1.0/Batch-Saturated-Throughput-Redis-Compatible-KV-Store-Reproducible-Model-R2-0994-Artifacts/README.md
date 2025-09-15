# Batch-Saturated Single-Thread Throughput in a Redis-Compatible In-Memory KV Store: A Reproducible Model with R² ≈ 0.994

**Author:** Darreck Lamar Bender II  
**Organization:** Laminar Instruments Inc.  
**Date:** September 15, 2025

## Abstract

We engineered CQDAM Engine v1.0, a single-thread, Redis-compatible in-memory KV server whose throughput under pipelined workloads follows the batched-service model T(p) = p/(t₀ + t₁p). Identification on commodity hardware yields t₀ and t₁ that map to fixed per-flush work and marginal per-operation work; the fit achieves R² ≈ 0.994 in the admissible region. Three invariants—pipeline closure T · p50s ≤ C · p, syscalls/op ≈ 2/(Cp), and a tight cycles/op band—hold pointwise and explain the observed scaling. Same-box baselines at C = 50, p = 100 show per-core throughput and latency advantages that align with the model and with syscall and energy measurements. The implementation demonstrates the principles of the Congruent Quantum Data Architecture Method (CQDAM) patent application, achieving reduced energy per operation and improved throughput density. The artifact package enables independent replication and scrutiny. Future work extends the method to online estimation of (t₀,t₁), an adaptive pipeline controller that enforces p95 SLOs while maximizing throughput, tail-bound derivation from probe histograms, and protocol generalization.

## Key Results

- **Mathematical Model:** T(p) = p/(t₀ + t₁p) with R² ≈ 0.994
- **Model Parameters:** t₀ = 5.49 μs/batch, t₁ = 69.6 ns/op  
- **Performance Improvement:** 2.11× throughput vs Redis at C=50, p=100
- **Energy Efficiency:** 2× improvement in μJ/op compared to Redis
- **Memory Efficiency:** 2× improvement in bytes/entry vs standard hash tables
- **Three System Invariants:** All validated across measurement range

## Quick Start

### Prerequisites
- Python 3.8+ with numpy, pandas, matplotlib, scipy
- Redis server and redis-benchmark (for baseline comparisons)
- macOS or Linux system

### One-Command Reproduction
```bash
# Reproduce all results and generate figures
./reproduce-all-results.sh
```

### Manual Analysis Steps
```bash
# 1. Install CQDAM Free Edition
cd CQDAM-FREE-EDITION-v1.0
chmod +x install.sh
./install.sh

# 2. Fit the throughput model
cd analysis
python3 fit-throughput-model.py

# 3. Validate system invariants  
python3 validate-invariants.py

# 4. Generate all paper figures
python3 generate-figures.py
```

## Package Contents

### Research Paper
- `paper.pdf` - Complete 35-page research paper with mathematical derivations

### Experimental Data
- `data/bench/` - 137 CSV files with throughput/latency measurements
- `data/energy/` - Power consumption logs from powermetrics/RAPL
- `data/syscalls/` - System call traces from strace/dtruss  
- `data/perf/` - Performance counter data
- `data/manifest.json` - Data integrity verification hashes

### Analysis Scripts
- `analysis/fit-throughput-model.py` - Reproduces R² ≈ 0.994 model fit
- `analysis/validate-invariants.py` - Validates three system invariants
- `analysis/generate-figures.py` - Generates all paper figures
- `analysis/statistical-analysis.ipynb` - Complete statistical analysis

### Software
- `CQDAM-FREE-EDITION-v1.0/` - Pre-compiled CQDAM binary and installation
- `baselines/` - Redis/KeyDB configuration for fair comparisons

## Mathematical Model

The core contribution is a reproducible identification of the batched-service throughput model:

```
T(p) = p/(t₀ + t₁p)
```

Where:
- T(p) = sustained throughput (operations/second)
- p = pipeline depth (operations per batch)
- t₀ = fixed per-batch service time (5.49 μs/batch)
- t₁ = marginal per-operation time (69.6 ns/op)

**Model Validation:**
- R² ≈ 0.994 across admissible region
- 95% confidence intervals provided
- Residual analysis confirms model assumptions
- Bootstrap validation with 1000 resamples

## System Invariants

Three invariants explain the observed scaling behavior:

1. **Pipeline Closure:** T · p50s ≤ C · p
2. **Syscall Budget:** syscalls/op ≈ 2/(Cp)  
3. **Cycles/op Band:** Fixed payload → tight efficiency band

All invariants validated pointwise across measurement data.

## Performance Claims

**Throughput Improvements (C=50, p=100):**
- CQDAM: 8.33 Mops/s
- Redis: 3.95 Mops/s  
- **Improvement: 2.11×**

**Energy Efficiency:**
- CQDAM: 0.342 μJ/op
- Redis: 0.687 μJ/op
- **Improvement: 2.0×**

**Memory Efficiency:**
- CQDAM: 64 bytes/entry
- Standard HashMap: 128 bytes/entry
- **Improvement: 2.0×**

## Reproducibility

### Data Integrity
All CSV files include SHA-256 hashes in `manifest.json` for verification.

### Experimental Protocol  
Complete methodology documented including:
- Hardware specifications (Apple M2, Intel/AMD x86_64)
- Software versions (OS, compiler, baseline systems)  
- Measurement procedures (warm-up, steady-state windows)
- Statistical analysis (OLS regression, confidence intervals)

### Independent Verification
The artifact package enables independent researchers to:
1. Verify the R² ≈ 0.994 model fit
2. Reproduce all paper figures
3. Validate system invariants
4. Compare against Redis baselines
5. Extend analysis with additional data

## Technical Details

**Architecture:**
- Single-thread event loop with native readiness API
- Span-based RESP parsing (zero-copy)
- Power-of-two hash table with DJB2 hashing
- Ring buffer responses with vectorized I/O
- Zero-allocation hot path design

**Measurement Infrastructure:**
- Prometheus-compatible metrics export
- Performance counter integration (perf/instruments)
- Energy measurement via powermetrics/RAPL
- Syscall tracing with strace/dtruss
- Statistical validation framework

## Citation

```bibtex
@article{bender2025batch,
  title={Batch-Saturated Single-Thread Throughput in a Redis-Compatible 
         In-Memory KV Store: A Reproducible Model with R² ≈ 0.994},
  author={Bender II, Darreck Lamar},
  organization={Laminar Instruments Inc.},
  year={2025},
  note={Reproducible research artifact available at: 
        https://github.com/LaminarInstruments/CQDAM-Artifacts}
}
```

## Support and Contact

**Technical Support:** support@laminarinstruments.com  
**Research Inquiries:** research@laminarinstruments.com  
**Patent Information:** patents@laminarinstruments.com

## License and Copyright

© 2025 Laminar Instruments Inc. All rights reserved.

**Research Data:** Creative Commons Attribution 4.0 International License  
**Software:** CQDAM Free Edition License (see CQDAM-FREE-EDITION-v1.0/LICENSE.txt)  
**Patents:** CQDAM and related technologies protected by pending patent applications

The mathematical model T(p) = p/(t₀ + t₁p) and experimental methodology are released under CC-BY-4.0 for academic use. Commercial applications require licensing from Laminar Instruments Inc.

---

**Laminar Instruments Inc.**  
*Advancing the State of the Art in High-Performance Computing*  
September 15, 2025