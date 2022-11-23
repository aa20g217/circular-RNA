#############################################
######### Allignment
#############################################
read1=()
for i in $(ls /root/tempDir/*R1.fastq.gz);do read1[${#read1[@]}]=${i}; done

read2=()
for i in $(ls /root/tempDir/*R2.fastq.gz);do read2[${#read2[@]}]=${i}; done
len=${#read1[@]}

echo {$read1}
echo {$read2}

mkdir /root/results/
mkdir /root/results/allignment
cd /root/results/allignment

for (( i=0; i<$len; i++ ));
do
STAR --genomeDir $1 \
--readFilesIn ${read1[$i]} ${read2[$i]} \
--readFilesCommand gunzip -c \
--outFileNamePrefix ${read1[$i]##*/}"_" \
--chimSegmentMin 10 ;
done


#############################################
######### Parsing
#############################################


mkdir /root/results/parsing
cd /root/results/parsing

for filename in /root/results/allignment/*Chimeric.out.junction;
do
f="$(basename -- $filename)";
echo ${f}
CIRCexplorer2 parse -t STAR $filename -b ${f%%Chimeric.out.junction}back_spliced_junction.bed> ${f%%Chimeric.out.junction}CIRCexplorer2_parse.log;
done

#############################################
######### Annotation
#############################################
mkdir /root/results/annotation
cd /root/results/annotation

for filename in /root/results/parsing/*back_spliced_junction.bed;
do
f="$(basename -- $filename)";
echo $filename;

CIRCexplorer2 annotate -r $2 -g $3 -b $filename -o ${f%%back_spliced_junction.bed}circularRNA_known.txt > ${f%%back_spliced_junction.bed}CIRCexplorer2_annotate.log;


done
