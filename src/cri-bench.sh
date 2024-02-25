#!/bin/bash

# Written by: Benjamin Rohner
# Written on: 2024-02-25
# Written to: Benchmark a system in a convenient one-run script

# Parameter testLength
if [[ -z $1 ]];
then 
    testLength=60
else
    testLength=$1
fi

# Run sysbench
# Get cores
# Note: hyper-threads *should* show as logical processors
cores=$(nproc)
overloadCores=$((cores * 8))

echo "  -----==============================================----   "
echo "--===={            Welcome to CRI-BENCH!             }====--"
echo "  -----==============================================----   "
echo "Cores:             $cores"
echo "Overload Cores:    $overloadCores"
echo "Test interval:     $testLength"

# Test single-core !!DISABLED!! Ignores time.
echo "  -----==============================================----   "
echo "--===={ Running single-core CPU test (sysbench cpu)  }====--"
echo "  -----==============================================----   "
sysbench --threads=1 --time=$testLength --report-interval=10 cpu run

# Test full CPU
echo "  -----==============================================----   "
echo "--===={ Running CPU test on all cores (sysbench cpu) }====--"
echo "  -----==============================================----   "
sysbench --threads=$cores --time=$testLength --report-interval=10 cpu run


# Test overloaded CPU
echo "  -----==============================================----   "
echo "--===={ Running CPU scheduler test (sysbench threads) }====--"
echo "  -----==============================================----   "
sysbench --threads=$overloadCores --thread-locks=$overloadCores --time=$testLength --report-interval=10 threads run

# Test mutex implementation !!DISABLED!! I don't know what this does
#echo "Running CPU mutex test (sysbench mutex)"
#sysbench --threads=$cores --time=$testLength --report-interval=10 mutex run

# Test memory speed
echo "  -----==============================================----   "
echo "--===={ Running random access memory test (1KB blocks) }====--"
echo "  -----==============================================----   "
sysbench --threads=$cores --time=$testLength --report-interval=10\
    --memory-block-size=1k --memory-total-size=100T memory run
echo "  -----==============================================----   "
echo "--===={ Running sequential memory test (1MB blocks) }====--"
echo "  -----==============================================----   "
sysbench --threads=$cores --time=$testLength --report-interval=10\
    --memory-block-size=1M --memory-total-size=100T memory run

echo "  -----==============================================----   "
echo "--===={ Running BIG memory test (1GB blocks) }====--"
echo "  -----==============================================----   "
sysbench --threads=$cores --time=$testLength --report-interval=10\
    --memory-block-size=1G --memory-total-size=100T memory run


# Run Geekbench Tests
echo "  -----==============================================----   "
echo "--===={              Running Geekbench 6              }====--"
echo "  -----==============================================----   "
./cri-bench/geekbench6/geekbench6