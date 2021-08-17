#/bin/bash -l
#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --time=7-0:00

cd /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506/

#collect absolute paths *fastq.gz into a one location
find "$(pwd)" -name *.fastq.gz > /mnt/lustre/groups/herv_msc/kaye/data/fastqc/fastq_file_paths.txt

cd /mnt/lustre/groups/herv_msc/kaye/data/fastqc

# field separator is "/" print column 8 to folders.txt = list of all folder names for participants
cat fastq_file_sorted.txt | awk -F "/" '{print $8}' > folders.txt

#move to untrimmed folder ensure folders.txt is inside
mkdir untrimmed
mv folders.txt untrimmed/
cd untrimmed/

for i in $(cat folders.txt); do mkdir $i ;fastqc -t 10 -o $i /mnt/lustre/datasets/trem2/seqs/RDobson_KAPATotalRNA_GC-RD-4193_310316-29525506\/$i\/*.fastq.gz ;done
