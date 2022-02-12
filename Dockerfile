FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

# This command compiles your app using GCC, adjust for your source code
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN apt-get -y update
RUN apt-get -y install openssh-server
RUN apt-get -y install gdb gdbserver
RUN apt-get -y install cmake git
RUN apt-get -y install sudo
RUN apt-get -y install wget

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN echo "export CUDA_HOME=/usr/local/cuda\nexport LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64\nexport PATH=\$PATH:\$CUDA_HOME/bin" > ~/.bashrc


RUN apt-get -y install curl python3-distutils

RUN mkdir /root/python_settings/
WORKDIR /root/python_settings/
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

RUN python3 -m pip install conan

RUN mkdir /root/.ssh

RUN service ssh start

EXPOSE 22

RUN conan config set general.sysrequires_mode=enabled


RUN mkdir /root/src
COPY . /root/src
RUN mkdir /root/src/conan_build

WORKDIR /root/src/conan_build

RUN conan profile update settings.compiler.libcxx=libstdc++11 default
RUN conan install ..

LABEL Name=cudadevelop
