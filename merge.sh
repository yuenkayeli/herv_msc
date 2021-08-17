#!/bin/bash

#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=1-0:00
#SBATCH --job-name=merge

#input: list of all *ERVresults.txt in one folder
#extract and place in new dir ERVcounts
#mkdir /mnt/lustre/groups/herv_msc/kaye/ERVresults_all
#find /mnt/lustre/groups/herv_msc/kaye/ervmap_pipeline/ -iname 'RDobson-*.ERVresults.txt' -exec cp {} ../ERVresults_all/ \;
cd /mnt/lustre/groups/herv_msc/kaye/ERVresults_all

# merge per participant  and add count values

for i in /mnt/lustre/groups/herv_msc/kaye/ERVresults_all/RDobson-*_*.ERVresults.txt
do
DIRNAME=$(basename -a $i)
t=${DIRNAME:0:-26}
#echo $t

#select erv_id on column 4 and make *ervid-txt file 
paste $t*.ERVresults.txt | grep -v "_" | awk '{printf "%s", $4; printf "\n" }' > $t.ervid_txt

#take all erv counts from column 7 
paste $t*.ERVresults.txt | grep -v "_" | awk '{for (i=7;i<=NF;i+=7) printf "%s\t", $i; printf "\n" }' > $t.ervcount_txt


#sum together counts in $t.ervcount_txt
awk '{X=$0}{split(X,x)}{print x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]+x[9]+x[10]+x[11]+x[12]+x[13]+x[14]+x[15]+x[16]+x[17]+x[18]+x[19]+x[20]+x[21]+x[22]+x[23]+x[24]+x[25]+x[26]+x[27]+x[28]}' $t.ervcount_txt| tr " " "\t" > $t.totalcount_txt


#put together ERV id with counts
paste $t.ervid_txt $t.totalcount_txt > $t.id_count_txt

#label columns
sed -e '1i\erv-id\t \'$t'' $t.id_count_txt  | cut -f1-2 > $t.final_txt

#create matrix for all samples gene-id , RDobson-*
paste RDobson-*.final_txt | grep -v "_" | awk '{printf "%s\t", $1}{for (i=2;i<=NF;i+=2) printf "%s\t", $i; printf "\n" }' > finalmatrix.txt

done

#rm extra files
rm RDobson-*_txt
