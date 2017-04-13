# Defines a base Ubuntu 16 Singularity container with basic Python packages
# uses pip to install numpy so it detects and takes advantage of OpenBLAS
# OpenBLAS is optimized for multiple CPU archs, on par with MKL for SSE and AVX 
# and about 30% slower for AVX2


# bootstraping from docker image is faster and includes more dependencies
BootStrap: docker
From: ubuntu:16.10

# alternatively we can bootstrap directly from the repo, but installation will be longer
#BootStrap: debootstrap
#OSVersion: xenial
#MirrorURL: http://us.archive.ubuntu.com/ubuntu/
#Include: rpm2cpio


%runscript
    echo "Arguments received: $*"
    exec /usr/bin/python "$@"

%setup
    # Runs from outside the container during Bootstrap
    # for example how to use this section see
    # https://github.com/mcuma/chpc_singularity/blob/master/tensorflow/ubuntu16-tensorflow-1.0.1-gpu.def


%post
    # Runs within the container during Bootstrap
    env
    env | grep proxy | true

    # Install the commonly used packages (from repo)
    apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        curl \
        git \
        libopenblas-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libpng-dev \
        libzmq3-dev \
        python-pip \
        pkg-config \
        python-dev \
        python-setuptools \
        rsync \
        software-properties-common \
        unzip \
        vim \
        zip \
        zlib1g-dev
    apt-get clean

    # Set up some required environment defaults
    #MC issue with locale (LC_ALL, LANGUAGE), to get it right:
    locale-gen "en_US.UTF-8" 
    dpkg-reconfigure locales 
    export LANGUAGE="en_US.UTF-8"
    echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
    echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

    # Update to the latest pip (newer than repo)
    pip install --no-cache-dir --upgrade pip
    
    # Install other commonly-needed python packages
    pip install --no-cache-dir --upgrade \
        future \
        matplotlib \
        scipy 

    #for OpenBLAS accelerated Python3 NumPy, install through pip3
    apt-get install -y python3-pip
    pip3 install --no-cache-dir --upgrade pip
    pip3 install --no-cache-dir --upgrade pip
    pip3 install --no-cache-dir --upgrade future matplotlib scipy

    # need to create mount point for home dir
    mkdir /uufs
    mkdir /scratch

    # git, wget
    apt-get install -y git wget
    # LMod
    apt-get install -y liblua5.1-0 liblua5.1-0-dev lua-filesystem-dev lua-filesystem lua-posix-dev lua-posix lua5.1

#   Singularity inherits hosts environment = all LMod environment variables
#   to get LMod in the container, we have to build it using the container
#   in the sys branch, and then user has to have this in ~/.custom.sh
#export OSVER=`lsb_release -r | awk '{ print $2; }'`
#export OSREL=`lsb_release -i | awk '{ print $3; }'`
#
#if [ -n "$SINGULARITY_CONTAINER" ] && [ -n "$SINGULARITY_MOD" ]; then
#  if [ $OSREL == "CentOS" ]; then # assume only CentOS7
#    source /uufs/chpc.utah.edu/sys/installdir/lmod/7.1.6-c7/init/bash
#  elif [ $OSREL == "Ubuntu" ]; then # assume only Ubuntu 16
#    source /uufs/chpc.utah.edu/sys/modulefiles/scripts/clear_lmod.sh
#    source /uufs/chpc.utah.edu/sys/installdir/lmod/7.4-u16/init/profile
#  fi
#fi
    echo "
export SINGULARITY_MOD=1
    " >> /environment

%test
    # Sanity check that the container is operating
    # make sure that numpy is using openblas
    /usr/bin/python -c "import numpy as np;np.__config__.show()"
