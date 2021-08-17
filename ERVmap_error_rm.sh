#!/bin/bash

#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=1-0:00
#SBATCH --mem=32GB
#SBATCH --job-name=ervmap

#error fixed but takes considerably longer than ERVmap_script.sh, error occurs due to contigs
#first sort fastq.gz files, then remove contigs from Aligned file and index, run STAR and BED separately

#load singlularity
module load apps/singularity/3.5.3
module load apps/samtools/1.10.0-singularity 

#first loop for lane 1

for i in /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/RD*
do
     DIRNAME=$(basename -a $i)
     
         if [[ ! -d ${DIRNAME} ]]
         then 
         mkdir /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}
         #echo $DIRNAME
                             
         #prepare FW_READ and RV_READ for STAR alignment format
         for a in $i/trimmomatic/*_L001_R1_001_1_paired.fq.gz
         do
        zcat $a | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
        bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
         FW_READ=${DIRNAME}_1.fq.gz
         done
         # echo $FW_READ
                                                                             
         for b in $i/trimmomatic/*_L001_R2_001_2_paired.fq.gz
         do
         zcat $b | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
         bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
         RV_READ=${DIRNAME}_2.fq.gz
         #echo $RV_READ
        done

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_1. --mode STAR

samtools view -h -b -L /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/ERVmap.bed /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.Aligned.sortedByCoord.out.bam > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp.bam

mv /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp.bam /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.Aligned.sortedByCoord.out.bam

samtools index /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.Aligned.sortedByCoord.out.bam

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_1. --mode BED


#run second loop for lane 2
 
     for a in $i/trimmomatic/*_L002_R1_001_1_paired.fq.gz
        do
        zcat $a | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
        bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
        FW_READ=${DIRNAME}_1.fq.gz
        done
        
        for b in $i/trimmomatic/*_L002_R2_001_2_paired.fq.gz
        do
        zcat $b | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
        bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
        RV_READ=${DIRNAME}_2.fq.gz
        done

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_2. --mode STAR

samtools view -h -b -L /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/ERVmap.bed /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.Aligned.sortedByCoord.out.bam > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp2.bam

mv /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp2.bam /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.Aligned.sortedByCoord.out.bam

samtools index /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.Aligned.sortedByCoord.out.bam

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_2. --mode BED

#run third loop for lane 3

for a in $i/trimmomatic/*_L003_R1_001_1_paired.fq.gz
    do
    zcat $a | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
    bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
    FW_READ=${DIRNAME}_1.fq.gz
    done
                                               
    for b in $i/trimmomatic/*_L003_R2_001_2_paired.fq.gz
    do
    zcat $b | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
    bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
    RV_READ=${DIRNAME}_2.fq.gz
    done

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_3. --mode STAR

samtools view -h -b -L /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/ERVmap.bed /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_3.Aligned.sortedByCoord.out.bam > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp3.bam

mv /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp3.bam /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_3.Aligned.sortedByCoord.out.bam

samtools index /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_3.Aligned.sortedByCoord.out.bam

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_3. --mode BED

#run fouth loop for lane 4

for a in $i/trimmomatic/*_L004_R1_001_1_paired.fq.gz
    do
    zcat $a | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
    bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq
    FW_READ=${DIRNAME}_1.fq.gz
    done
                                                
    for b in $i/trimmomatic/*_L004_R2_001_2_paired.fq.gz
    do
    zcat $b | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
    bgzip -f /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq
    RV_READ=${DIRNAME}_2.fq.gz
    done

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_4. --mode STAR
 
samtools view -h -b -L /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/ERVmap.bed /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_4.Aligned.sortedByCoord.out.bam > /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp4.bam

mv /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/temp4.bam /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_4.Aligned.sortedByCoord.out.bam

samtools index /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_4.Aligned.sortedByCoord.out.bam

singularity exec \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/data:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/reference/STAR_index_ens/:/genome:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/data/ERVmap-master/bed_chr/:/resources:ro \
    --bind /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/:/results \
    /mnt/lustre/groups/herv_msc/kaye/ervmap_latest.sif /scripts/ERVmapping.sh \
    --read1 /data/${DIRNAME}_1.fq.gz \
    --read2 /data/${DIRNAME}_2.fq.gz \
    --output /${DIRNAME}_4. --mode BED

 rm  /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_1.fq.gz /mnt/lustre/groups/herv_msc/kaye/chr/${DIRNAME}/${DIRNAME}_2.fq.gz
    
    fi
done
