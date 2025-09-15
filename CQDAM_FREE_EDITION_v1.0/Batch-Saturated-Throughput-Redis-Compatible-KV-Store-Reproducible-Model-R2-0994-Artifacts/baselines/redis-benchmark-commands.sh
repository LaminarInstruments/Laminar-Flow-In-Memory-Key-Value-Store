#!/bin/bash
#
# Redis Baseline Benchmark Commands
# Fair comparison configurations for CQDAM vs Redis
#
# Author: Darreck Lamar Bender II
# Organization: Laminar Instruments Inc.
# Date: September 15, 2025
#

echo "Redis Baseline Benchmark Commands"
echo "================================="
echo

# Configuration for fair comparison
REDIS_PORT=6380  # Use different port from CQDAM (6379)
CLIENTS=50       # Fixed client count from paper
OPERATIONS=10000000  # Sufficient for stable measurements
VALUE_SIZE=64    # Fixed payload size

echo "Configuration:"
echo "- Redis Port: $REDIS_PORT"
echo "- Clients: $CLIENTS"
echo "- Operations: $OPERATIONS" 
echo "- Value Size: $VALUE_SIZE bytes"
echo

# Start Redis server with fair configuration
start_redis_server() {
    echo "Starting Redis server (fair comparison configuration)..."
    echo "Command:"
    echo "redis-server --port $REDIS_PORT --save '' --appendonly no --protected-mode no --maxmemory 0 --daemonize yes"
    echo
    
    # Uncomment to actually start Redis:
    # redis-server --port $REDIS_PORT --save '' --appendonly no --protected-mode no --maxmemory 0 --daemonize yes
    
    echo "Note: Run the above command to start Redis for baseline comparison"
    echo
}

# Pipeline depth sweep (matching paper methodology)
pipeline_sweep() {
    echo "Pipeline Depth Sweep Commands:"
    echo "=============================="
    
    for P in 1 10 50 100 200 500; do
        echo "# Pipeline depth P=$P"
        echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P $P -n $OPERATIONS -t set,get -d $VALUE_SIZE --csv > redis_baseline_C${CLIENTS}_P${P}.csv"
        echo
    done
}

# Mixed workload test (paper's canonical comparison)
canonical_comparison() {
    echo "Canonical Comparison (C=50, P=100):"
    echo "===================================="
    
    P=100
    echo "# SET operations"
    echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P $P -n $OPERATIONS -t set -d $VALUE_SIZE --csv > redis_set_C${CLIENTS}_P${P}.csv"
    echo
    
    echo "# GET operations" 
    echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P $P -n $OPERATIONS -t get -d $VALUE_SIZE --csv > redis_get_C${CLIENTS}_P${P}.csv"
    echo
    
    echo "# Mixed operations"
    echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P $P -n $OPERATIONS -t set,get -d $VALUE_SIZE --csv > redis_mixed_C${CLIENTS}_P${P}.csv"
    echo
}

# Payload size sweep
payload_sweep() {
    echo "Payload Size Sweep (P=100):"
    echo "============================"
    
    P=100
    for SIZE in 16 64 256 1024; do
        echo "# Payload size: $SIZE bytes"
        echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P $P -n $OPERATIONS -t set,get -d $SIZE --csv > redis_payload_${SIZE}B_C${CLIENTS}_P${P}.csv"
        echo
    done
}

# Full benchmark suite
run_full_suite() {
    echo "Full Redis Baseline Suite:"
    echo "=========================="
    echo "#!/bin/bash"
    echo "# Complete Redis baseline benchmarking"
    echo "set -e"
    echo
    
    # Start server
    echo "# Start Redis server"
    echo "redis-server --port $REDIS_PORT --save '' --appendonly no --protected-mode no --maxmemory 0 --daemonize yes"
    echo "sleep 3"
    echo
    
    # Verify server is running
    echo "# Verify server"
    echo "redis-cli -p $REDIS_PORT ping"
    echo
    
    # Run all benchmarks
    echo "# Pipeline sweep"
    for P in 1 10 50 100 200 500; do
        echo "echo 'Running P=$P...'"
        echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P $P -n $OPERATIONS -t set,get -d $VALUE_SIZE --csv > redis_baseline_C${CLIENTS}_P${P}.csv"
        echo "sleep 5  # Cool down between tests"
    done
    echo
    
    echo "# Payload size sweep"
    for SIZE in 16 64 256 1024; do
        echo "echo 'Running payload size ${SIZE}B...'"
        echo "redis-benchmark -h 127.0.0.1 -p $REDIS_PORT -c $CLIENTS -P 100 -n $OPERATIONS -t set,get -d $SIZE --csv > redis_payload_${SIZE}B.csv"
        echo "sleep 5"
    done
    echo
    
    echo "# Analysis"
    echo "echo 'Analyzing results...'"
    echo "python3 ../analysis/compare_baselines.py"
    echo
    
    echo "echo 'Redis baseline benchmarking complete'"
}

# Main execution
main() {
    echo "This script provides the exact redis-benchmark commands used for"
    echo "baseline comparisons in the CQDAM research paper."
    echo
    echo "To ensure fair comparison with CQDAM:"
    echo "1. Use same client count (C=$CLIENTS)"
    echo "2. Use same pipeline depths (P=1,10,50,100,200,500)"
    echo "3. Use same payload sizes (16,64,256,1024 bytes)"
    echo "4. Disable Redis persistence (--save '' --appendonly no)"
    echo "5. Use same measurement duration and warm-up procedures"
    echo
    
    start_redis_server
    pipeline_sweep
    canonical_comparison
    payload_sweep
    
    echo "=========================================="
    echo "Complete benchmark suite script:"
    echo "=========================================="
    run_full_suite > redis_complete_baseline.sh
    chmod +x redis_complete_baseline.sh
    echo "Generated: redis_complete_baseline.sh"
    echo
    echo "To run complete baseline comparison:"
    echo "./redis_complete_baseline.sh"
}

# Execute
main "$@"