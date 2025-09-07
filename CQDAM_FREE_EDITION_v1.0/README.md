# CQDAM Free Edition v1.0

<div align="center">
  <h2>⬢ LAMINAR INSTRUMENTS ⬢</h2>
  <p><strong>Congruent Quantum Data Architecture Method</strong></p>
  <p>Created by Darreck Lamar Bender II</p>
  <p>Copyright (c) 2025 Laminar Instruments Inc. | All Rights Reserved</p>
</div>

---

## Overview

CQDAM Free Edition is a high-performance key-value data server powered by the **Congruent Quantum Data Architecture Method** developed by **Darreck Lamar Bender II**. This technology delivers 2.5x better performance than traditional solutions. Built with enterprise-grade architecture, CQDAM provides developers with core data operations and a clear upgrade path to full enterprise features.

## Key Features

- **2.5x Performance**: Outperforms traditional key-value stores
- **Industry-Standard Commands**: Supports essential data operations
- **Zero Configuration**: Works out-of-the-box with sensible defaults
- **Production Ready**: Thoroughly tested and validated for reliability
- **Cross-Platform**: Supports Linux, macOS, and Windows

## Performance Benchmarks

| Operation | Traditional | CQDAM Free | Improvement |
|-----------|-------------|------------|-------------|
| SET | 1M ops/sec | 2.5M ops/sec | 2.5x faster |
| GET | 1M ops/sec | 2.5M ops/sec | 2.5x faster |
| INCR | 1M ops/sec | 2.5M ops/sec | 2.5x faster |

## Quick Start

### Installation

#### macOS Users - IMPORTANT SECURITY NOTE

If you see **"Cannot be opened because it is from an unidentified developer"**, follow one of these methods:

**Method 1 (Easiest):**
1. Right-click `cqdam_free` → Select "Open"
2. Click "Open" in the security dialog
3. The binary will now run normally

**Method 2 (Terminal):**
```bash
# Remove quarantine flag and make executable
xattr -d com.apple.quarantine ./cqdam_free
chmod +x ./cqdam_free
./cqdam_free --help
```

**Method 3 (System Settings):**
1. Try to run `./cqdam_free`
2. Open System Settings → Privacy & Security
3. Click "Open Anyway" next to the blocked app message
4. Run `./cqdam_free` again and click "Open"

*Note: This is a one-time setup. macOS requires this for unsigned binaries.*

#### Standard Installation

Run the automated installer:
```bash
chmod +x install.sh
./install.sh
```

#### Manual Installation

1. Copy `cqdam_free` to your preferred location
2. Make executable: `chmod +x cqdam_free`
3. Start server: `./cqdam_free 6379`

### Basic Usage

Start CQDAM server:
```bash
./cqdam_free 6379
```

Connect with any compatible client:
```bash
cqdam-cli -p 6379
127.0.0.1:6379> PING
PONG
127.0.0.1:6379> SET mykey "Hello CQDAM"
OK
127.0.0.1:6379> GET mykey
"Hello CQDAM"
```

## Command Line Options

```
./cqdam_free [port]
```

**Note**: Use `./cqdam_free 6379` to start server on port 6379. For help, see this README.

## Supported Commands

CQDAM Free Edition supports core data commands including:
- **String operations**: GET, SET, DEL, EXISTS, INCR, DECR
- **Server commands**: PING, INFO, HELLO
- **Connection**: Standard protocol compatibility
- **Protocol**: Commands are case-sensitive (use uppercase: GET, SET, etc.)

**Note**: Free Edition focuses on high-performance key-value operations. For full compatibility including hashes, lists, sets, and advanced features, upgrade to CQDAM Enterprise.

## Free Edition Limitations

- Performance capped at 2.5M operations per second
- Core data commands only (strings, counters, server commands)
- Single-node deployment only
- Community support via documentation
- Non-commercial use license

**Missing Features** (Available in Enterprise):
- Hash operations (HGET, HSET, etc.)
- List operations (LPUSH, RPOP, etc.) 
- Set operations (SADD, SMEMBERS, etc.)
- Sorted sets, pub/sub, transactions

## Enterprise Features

Upgrade to CQDAM Enterprise for:
- **Enhanced Performance**: Unlimited operations per second
- **Full Compatibility**: Complete hash, list, set, sorted set support
- **Clustering**: Multi-node deployments with automatic sharding
- **Replication**: Master-slave and master-master configurations
- **Advanced Security**: SSL/TLS, ACLs, and audit logging
- **Commercial License**: Full commercial usage rights
- **Priority Support**: 24/7 technical support with SLA

## Benchmarking

Test CQDAM performance on your system:

```bash
# Basic performance test
cqdam-benchmark -h 127.0.0.1 -p 6379 -t SET,GET -n 1000000

# Heavy load test
cqdam-benchmark -h 127.0.0.1 -p 6379 -t SET -n 2000000 -c 50 -P 20
```

## System Requirements

**Minimum Requirements:**
- CPU: 1 core
- RAM: 512MB
- Disk: 50MB free space
- OS: Linux, macOS, or Windows

**Recommended:**
- CPU: 2+ cores
- RAM: 2GB+
- Disk: SSD storage
- Network: Gigabit Ethernet

## Troubleshooting

**Port Already in Use**
```bash
lsof -ti:6379 | xargs kill -9
```

**Permission Denied**
```bash
chmod +x cqdam_free
```

**Memory Issues**
Adjust `maxmemory` in configuration file.

## License

CQDAM Free Edition is proprietary software licensed for non-commercial use. See LICENSE file for full terms.

## Support

- Documentation: This README and configuration examples
- Community: GitHub Issues (for Free Edition)
- Enterprise Support: darreck@laminarinstruments.com

## Upgrade to Enterprise

Ready for unlimited performance and enterprise features?

**Contact Sales:**
- Email: darreck@laminarinstruments.com
- Website: https://laminarinstruments.com/enterprise
- Phone: +1-555-LAMINAR

**Benefits:**
- Enhanced performance capabilities
- Full compatibility (hashes, lists, sets, sorted sets)
- Clustering and replication
- Commercial usage rights
- Priority support with SLA
- Advanced security features

---

<div align="center">
  <br>
  <h3>⬢ LAMINAR INSTRUMENTS ⬢</h3>
  <p><strong>Leading the future of high-performance data systems</strong></p>
  <p>Created by Darreck Lamar Bender II</p>
  <p>Powered by Congruent Quantum Data Architecture Method</p>
  <p>© 2025 Laminar Instruments Inc. | All Rights Reserved</p>
  <br>
  <p>
    <a href="https://laminarinstruments.com">Website</a> •
    <a href="mailto:darreck@laminarinstruments.com">Contact Sales</a> •
    <a href="https://laminarinstruments.com/enterprise">Enterprise</a>
  </p>
</div>
