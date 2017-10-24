imgname=python
osname=ubuntu
rm -f ${osname}_${imgname}.img
# final version of container, read only (singularity shell -w will not work)
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.4/bin/singularity build ${osname}_${imgname}.simg Singularity
# sandbox image, allows container modification
#sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.4/bin/singularity build -s /var/tmp/${osname}_${imgname}.simg Singularity


