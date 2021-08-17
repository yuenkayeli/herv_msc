#!/bin/bash -l
#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --time=7-0:00

mkdir /mnt/lustre/groups/herv_msc/kaye/data/fastqc/trimmomatic
cd /mnt/lustre/groups/herv_msc/kaye/data/fastqc/trimmomatic

for a in $(cat trimmomatic_folders.txt); do mkdir $a ;fastqc -t 16 -o $a /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/$a\/trimmomatic/*_paired.fq.gz ;done
