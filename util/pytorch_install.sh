#!/bin/bash
source activate
cd /data/pytorch
USE_ROCM=1 MAX_JOBS=6 python setup.py install --user

cd /data/vision 
python setup.py install

cd /data/pytorch/examples/mnist
pip install -r requirements.txt
