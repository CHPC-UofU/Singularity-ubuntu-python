imgname=python
osname=ubuntu
rm -f ${osname}_${imgname}.img
# final version of container, read only (singularity shell -w will not work)
sudo singularity build ${osname}_${imgname}.simg Singularity
# sandbox image, allows container modification
#sudo singularity build -s /var/tmp/${osname}_${imgname}.simg Singularity


