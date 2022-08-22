FROM ubuntu:20.04

ENV TZ=America/Boise
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y --purge && \
    apt-get install -y tzdata cpio python3 gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath python vim locales zstd liblz4-tool
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN useradd -ms /bin/bash dkr -G sudo
USER dkr
WORKDIR /home/dkr

RUN git clone -b dunfell git://git.yoctoproject.org/poky.git poky-dunfell
RUN cd poky-dunfell && \
    git clone -b dunfell git://git.openembedded.org/meta-openembedded --depth=1 && \
    git clone -b dunfell git://git.yoctoproject.org/meta-raspberrypi --depth=1 && \
    git clone -b dunfell https://github.com/meta-qt5/meta-qt5.git --depth=1 && \
    git clone -b dunfell git://git.yoctoproject.org/meta-security --depth=1 && \
    git clone -b dunfell https://github.com/jumpnow/meta-jumpnow --depth=1
RUN cd /home/dkr && \
    mkdir rpi && \
    cd rpi && \
    git clone -b dunfell https://github.com/jumpnow/meta-rpi --depth=1

COPY build.sh /home/dkr/build.sh

RUN git config --global --add safe.directory '*'

CMD ["/bin/bash", "/home/dkr/build.sh"]