
# RepeatModeler
nohup /home/ssushko/repeatmasker_resources/RepeatModeler-master/RepeatModeler -database cardui -threads 8 -LTRStruct >& run2.out &

# cd-hit-est clustering
/home/ssushko/repeatmasker_resources/cdhit-master/cd-hit-est -i vcardui_denovo.fasta -o vcardui_clustered.fasta -T 5 -aS 0.8 -aL 0.8 -c 0.8

# added #MITE particle to MITE consensi
sed 's/|L.*/#MITE/g' vcardui_clustered_0.8.fasta > vcardui_clustered_0.8_namesright.fasta

# clustering after concatenating vcard an vatal libraries
nohup /home/ssushko/repeatmasker_resources/cdhit-master/cd-hit-est -i vcard-vatal_concat_TElib.fa -o vcard-vatal_concat_TElib_clustered.fa -T 5 -aS 0.8 -aL 0.8 >&cdhit.out &