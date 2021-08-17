#!/bin/bash -l

#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --time=1-0:00
#SBATCH --nodes=1
#SBATCH --ntasks=4

# dependancy
apps/multiqc/1.8-python3.7.3

#multiqc -o /mnt/lustre/groups/herv_msc/kaye/data/fastqc/untrimmed

#same script used for untrimmed and trimmomatic fastq data alter files
#
#multiqc for after alignment

#multiqc -o /mnt/lustre/groups/herv_msc/kaye/data/multiqc/multiqc_data_afteralignment /mnt/lustre/groups/herv_msc/kaye/results

multiqc -o /mnt/lustre/groups/herv_msc/kaye/data/multiqc/multiqc_ervmap. /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/
