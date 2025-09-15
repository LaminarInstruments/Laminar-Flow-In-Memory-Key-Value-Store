# CQDAM Free Edition v1.0 - Installation Guide

**Author:** Darreck Lamar Bender II  
**Organization:** Laminar Instruments Inc.  
**Version:** 1.0  
**Date:** September 15, 2025

## Overview

CQDAM Free Edition is a high-performance, single-thread, Redis-compatible in-memory key-value server that achieves multi-million operations per second with mathematical predictability.

**Key Features:**
- Redis-compatible RESP protocol
- Single-thread architecture for predictable performance  
- Batched-service throughput model: T(p) = p/(t₀ + t₁p)
- Energy-efficient operation (2× improvement vs Redis)
- Zero-allocation hot path design

## System Requirements

**Operating Systems:**
- macOS 10.14+ (Intel or Apple Silicon)
- Linux x86_64 (Ubuntu 18.04+, CentOS 7+, etc.)

**Hardware Requirements:**
- Minimum: 1 CPU core, 1GB RAM
- Recommended: 2+ CPU cores, 4GB+ RAM
- Network: Loopback or 1GbE+ for optimal performance

**Dependencies:**
- None (statically linked binary)

## Installation

### Quick Install
```bash
# Make binary executable
chmod +x cqdam_free

# Test installation
./cqdam_free --version

# Start server on default port (6379)
./cqdam_free
```

### Custom Installation
```bash
# Install to system location (optional)
sudo cp cqdam_free /usr/local/bin/
sudo chmod +x /usr/local/bin/cqdam_free

# Start from system location
cqdam_free
```

## Usage

### Basic Usage
```bash
# Start server on default port 6379
./cqdam_free

# Start on custom port
./cqdam_free 6380

# Show help
./cqdam_free --help
```

### Client Connections
CQDAM is Redis-compatible. Use any Redis client:

```bash
# Using redis-cli
redis-cli -p 6379 ping
redis-cli -p 6379 set mykey "Hello CQDAM"
redis-cli -p 6379 get mykey

# Using redis-benchmark for performance testing
redis-benchmark -h 127.0.0.1 -p 6379 -c 50 -P 100 -n 1000000 -t set,get
```

### Performance Optimization

**CPU Affinity (Linux):**
```bash
# Pin to specific CPU core
taskset -c 2 ./cqdam_free 6379
```

**Memory Settings:**
```bash
# Set memory limit (if supported)
./cqdam_free 6379 --max-memory 1GB
```

## Performance Characteristics

### Throughput Model
CQDAM follows the batched-service model:
```
T(p) = p/(t₀ + t₁p)
```
Where:
- T(p) = throughput (ops/sec)
- p = pipeline depth
- t₀ ≈ 5.49 μs/batch (fixed per-batch cost)
- t₁ ≈ 69.6 ns/op (marginal per-operation cost)

### Expected Performance
**Single Thread Performance:**
- Low pipeline (p=1): ~180K ops/sec
- Medium pipeline (p=50): ~5.6M ops/sec  
- High pipeline (p=100): ~8.3M ops/sec
- Theoretical maximum: ~14.4M ops/sec

**Energy Efficiency:**
- ~0.34 μJ/op (2× better than Redis)
- Scales with pipeline depth

## Supported Commands

CQDAM implements the core Redis command set:

**Basic Operations:**
- `SET key value` - Set key to value
- `GET key` - Get value of key
- `DEL key` - Delete key
- `EXISTS key` - Check if key exists

**Utility Commands:**
- `PING` - Server health check
- `INFO` - Server information
- `FLUSHALL` - Clear all keys

**Performance Commands:**
- `INCR key` - Increment counter
- `DECR key` - Decrement counter

## Configuration

### Runtime Configuration
CQDAM uses intelligent defaults optimized for performance:

- **Hash Table:** Power-of-two sizing with DJB2 hashing
- **Memory:** Zero-allocation hot path
- **I/O:** Vectorized writes with batched responses  
- **Concurrency:** Single-thread event loop

### Monitoring
Built-in performance metrics:
```bash
# Get server stats via Redis INFO command
redis-cli -p 6379 info
```

## Troubleshooting

### Common Issues

**Port Already in Use:**
```bash
# Check what's using the port
lsof -i :6379

# Use different port
./cqdam_free 6380
```

**Permission Denied:**
```bash
# Make sure binary is executable
chmod +x cqdam_free

# Check file permissions
ls -la cqdam_free
```

**Performance Issues:**
```bash
# Check CPU affinity
taskset -cp $$

# Monitor system load
top -p $(pgrep cqdam_free)

# Use redis-benchmark to verify performance
redis-benchmark -h 127.0.0.1 -p 6379 -c 50 -P 100 -t set
```

### Performance Validation
To verify CQDAM is performing as expected:

```bash
# Test with different pipeline depths
redis-benchmark -h 127.0.0.1 -p 6379 -c 50 -P 1 -n 100000 -t set
redis-benchmark -h 127.0.0.1 -p 6379 -c 50 -P 100 -n 100000 -t set

# Expected: Higher pipeline depth = higher throughput
# Model: T(p) = p/(5.49e-6 + 69.6e-9 * p)
```

## License and Support

### License
CQDAM Free Edition License - See LICENSE.txt

### Commercial License
For commercial deployments requiring:
- Multi-threading support
- Enterprise features  
- Commercial support
- Patent indemnification

Contact: license@laminarinstruments.com

### Support
- **Community Support:** GitHub Issues
- **Technical Documentation:** https://docs.laminarinstruments.com
- **Commercial Support:** support@laminarinstruments.com

### Research Citation
If using CQDAM in academic research:

```bibtex
@software{cqdam_free_2025,
  title={CQDAM Free Edition: High-Performance Redis-Compatible KV Store},
  author={Bender II, Darreck Lamar},
  organization={Laminar Instruments Inc.},
  version={1.0},
  year={2025},
  url={https://laminarinstruments.com/cqdam}
}
```

## Security Considerations

**Network Security:**
- CQDAM binds to localhost (127.0.0.1) by default
- For remote access, configure firewall appropriately
- Consider Redis AUTH if exposing to network

**Memory Security:**
- No persistence by design (pure in-memory)
- Data lost on process termination
- No encryption at rest

---

**CQDAM Free Edition v1.0**  
© 2025 Laminar Instruments Inc. All rights reserved.  
Patent-protected technology.