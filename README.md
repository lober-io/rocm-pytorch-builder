
# pyTORCH builder for ROCm

This builds the lastest pytorch for rocm in a prepared rocm-dev container and stores the result on your host system. (**The host needs to have the rocm kernel modules etc!**)

#  Design

The `start.sh` downloads anaconda, runs the container build and finally starts up the container.

In the container, the `pytorch_build.sh` script clones the pytorch git and all submodules, prepare the sources for amdgpu and start the build. Be aware that the build takes some time and the container can consume quite a lot of ram (16GB+). If the build fails, reduce `MAX_JOBS` in the `pytorch_build.sh` and run `start.sh` again or use `run_it.sh` to fix it in the container via `bash`.

You can control container name, tag and host mount path for pytorch via the `env.txt`.

To follow the build execute `docker logs -f rocm-pytorch-builder`.

## Target GPU
You need to change the `ENV HCC_AMDGPU_TARGET=` to match your target GPU.

*For example, gfx906 for vega 20 or gfx900 for vega 10*


# Tests

To test your pytorch you can run the container with `./run_it.sh` to run all pytorch test (also takes a while) 

```
./run_it.sh
cd /data/pytorch
PYTORCH_TEST_WITH_ROCM=1 python test/run_test.py --verbose
``` 

The script also clones the examples from pytorch and installs the mnist requirements.
You can run mnist via:

```
./run_it.sh
cd /data/pytorch/examples/mnist
python main.py
```

# Conclusion

This setup is pretty rudimentary and straight forward, without error handling or further logging.
If something goes wrong, run `./run_it.sh` and start `pytorch_build.sh` manually to debug it. Most of the time it will be a missing dependency or not matching software version.

You can get the output of the conatiner with `docker logs rocm-pytorch-builder`.

# Sources

https://rocm-documentation.readthedocs.io/en/latest/Deep_learning/Deep-learning.html#option-2-install-using-pytorch-upstream-docker-file

https://github.com/zhanghang1989/PyTorch-Encoding/issues/167
