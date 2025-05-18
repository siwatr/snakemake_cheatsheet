# Assuming you are in the root directory of this repository
# Reference Genome --------------------------------------------------------------------------------
# Download chr1 sequence from mm10 reference genome from UCSC
mkdir -p ./resource/ref_genome
curl --output ./resource/ref_genome/chr1.fa.gz https://hgdownload.soe.ucsc.edu/goldenPath/mm10/chromosomes/chr1.fa.gz
curl --output ./resource/ref_genome/ucsc_md5sum.txt https://hgdownload.soe.ucsc.edu/goldenPath/mm10/chromosomes/md5sum.txt

# Checking md5 sum (This may work differently on different OS)
local_md5=$(md5sum ./resource/ref_genome/chr1.fa.gz | cut -f 1 -d " ")
ref_md5=$(grep "chr1.fa.gz" ./resource/ref_genome/ucsc_md5sum.txt | cut -f 1 -d " ")

if [[ "$local_md5" != "$ref_md5" ]]; then
    echo "MD5 checksum does not match"
    echo "downloaded MD5:    $local_md5"
    echo "ref from UCSC MD5: $ref_md5"
    # exit 1
else
    echo "MD5 checksum matches"
fi


# Test sequence -----------------------------------------------------------------------------------
mkdir -p ./resource/fastq
scp hpcl:/fs/pool/pool-toti-bioinfo/bioinfo/siwat_chad/dev/lab_pipelines/snakemake_ngs/test/fastq/Nr_TIP_locusA.[12].fastq ./resource/fastq/
mv ./resource/fastq/Nr_TIP_locusA.1.fastq ./resource/fastq/test_R1.fastq
mv ./resource/fastq/Nr_TIP_locusA.2.fastq ./resource/fastq/test_R2.fastq
