#!/bin/bash -l
#COBALT -n 1 
#COBALT -t 60
#COBALT -q full-node

echo loading module $1
module load $1
conda activate

module list

echo python = $(which python)

NODES=`cat $COBALT_NODEFILE | wc -l`
#NODES=1
GPUS_PER_NODE=8
#GPUS_PER_NODE=1
RANKS=$((NODES * GPUS_PER_NODE))
echo NODES=$NODES  PPN=$PPN  RANKS=$RANKS

export OMP_NUM_THREADS=16

#mpirun -hostfile $COBALT_NODEFILE -n $RANKS -npernode $GPUS_PER_NODE -- python horovod_mnist.py -i /lus/theta-fs0/software/datascience/datasets/mnist.npz --horovod --interop $OMP_NUM_THREADS --intraop $OMP_NUM_THREADS
mpirun -x LD_LIBRARY_PATH -x PATH -x PYTHONPATH -np $((COBALT_JOBSIZE*8)) -npernode 8 --hostfile ${COBALT_NODEFILE} python horovod_mnist.py -i /lus/theta-fs0/software/datascience/datasets/mnist.npz --horovod --interop $OMP_NUM_THREADS --intraop $OMP_NUM_THREADS

