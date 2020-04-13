#!/bin/bash
source activate
cd /data
git clone https://github.com/ROCmSoftwarePlatform/pytorch.git
cd pytorch
git submodule init && git submodule update
git submodule update --init --recursive
python tools/amd_build/build_amd.py
USE_ROCM=1 MAX_JOBS=6 python setup.py install --user

cd /data
git clone https://github.com/pytorch/vision.git 
cd vision 
python setup.py install

cd /data/pytorch
git clone https://github.com/pytorch/examples.git
cd examples/mnist
pip install -r requirements.txt
