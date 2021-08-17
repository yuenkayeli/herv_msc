#!/bin/bash

#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=6-0:00
#SBATCH --mem=32GB
#SBATCH --job-name=em50

#load singlularity
module load apps/singularity/3.5.3

for i in /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/RDobson-5*
do
    DIRNAME=$(basename -a $i)

    if [[ ! -d ${DIRNAME} ]]
    then
        mkdir /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/${DIRNAME}
        #echo $DIRNAME

        #prepare FW_READ and RV_READ for STAR alignment format
        for a in $i/trimmomatic/*L001_R1_001_1_paired.fq.gz
        do
        FW_READ=$(basename -a $a)
        done
        # echo $FW_READ

        for b in $i/trimmomatic/*L001_R2_001_2_paired.fq.gz
        do
        RV_READ=$(basename -a $b)
        #echo $RV_READ
        done

singularity exec \
 --bind /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/${DIRNAME}/trimmomatic:/data:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/${DIRNAME}/:/results \
 /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
 --read1 /data/${FW_READ} \
 --read2 /data/${RV_READ} \
 --output /${DIRNAME}_1. --mode ALL
 
 #run second loop
        for a in $i/trimmomatic/*L002_R1_001_1_paired.fq.gz
        do
        FW_READ=$(basename -a $a)
        done
                                
       for b in $i/trimmomatic/*L002_R2_001_2_paired.fq.gz
       do
       RV_READ=$(basename -a $b)
       done

singularity exec \
 --bind /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/${DIRNAME}/trimmomatic:/data:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/${DIRNAME}/:/results \
 /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
 --read1 /data/${FW_READ} \
 --read2 /data/${RV_READ} \
 --output /${DIRNAME}_2. --mode ALL

#run third loop
for a in $i/trimmomatic/*L003_R1_001_1_paired.fq.gz
do
FW_READ=$(basename -a $a)
done

for b in $i/trimmomatic/*L003_R2_001_2_paired.fq.gz
do
RV_READ=$(basename -a $b)
done

singularity exec \
 --bind /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/${DIRNAME}/trimmomatic:/data:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/${DIRNAME}/:/results \
 /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
 --read1 /data/${FW_READ} \
 --read2 /data/${RV_READ} \
 --output /${DIRNAME}_3. --mode ALL

#run fouth loop
for a in $i/trimmomatic/*L004_R1_001_1_paired.fq.gz
do
FW_READ=$(basename -a $a)
done

for b in $i/trimmomatic/*L004_R2_001_2_paired.fq.gz
do
RV_READ=$(basename -a $b)
done

singularity exec \
 --bind /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/${DIRNAME}/trimmomatic:/data:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
 --bind /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/${DIRNAME}/:/results \
 /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
 --read1 /data/${FW_READ} \
 --read2 /data/${RV_READ} \
 --output /${DIRNAME}_4. --mode ALL

    fi 
done
