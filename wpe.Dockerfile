FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update --yes 
RUN apt-get install -qq software-properties-common build-essential wget python3 python3-pip \
	zlib1g-dev libssl-dev git psmisc vim curl iproute2 gdb htop --yes
RUN wget -O cmake.gpg https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null
RUN apt-key add cmake.gpg
RUN add-apt-repository 'deb https://apt.kitware.com/ubuntu/ focal main' --yes
RUN apt-get -qq update && apt-get -qq install cmake
RUN pip3 install jsonref --quiet

RUN mkdir -p /root/repos/
WORKDIR /root/repos
RUN git clone https://github.com/rdkcentral/Thunder.git && \
    git clone https://github.com/rdkcentral/ThunderNanoServices.git && \
    git clone https://github.com/rdkcentral/ThunderInterfaces.git && \
    git clone https://github.com/rdkcentral/ThunderClientLibraries.git

RUN mkdir -p /root/repos/Thunder/Tools/build \
                /root/repos/Thunder/build \
                /root/repos/ThunderInterfaces/build \
                /root/repos/ThunderClientLibraries/build

WORKDIR /root/repos/Thunder/Tools/build
RUN cmake .. -DBUILD_TYPE=Debug \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j $(nproc) install

WORKDIR /root/repos/Thunder/build
RUN cmake .. -DBUILD_TYPE=Debug \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j $(nproc) install

WORKDIR /root/repos/ThunderInterfaces/build
RUN cmake .. -DBUILD_TYPE=Debug \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j $(nproc) install

WORKDIR /root/repos/ThunderClientLibraries/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_TYPE=Debug \
        -DCOMPOSITORCLIENT=OFF \
        -DGSTREAMERCLIENT=OFF \
        -DDEVICEIDENTIFICATION=OFF \
        -DDISPLAYINFO=OFF \
        -DSECURITYAGENT=ON \
        -DPLAYERINFO=ON \
        -DPROVISIONPROXY=OFF \
        -DCDMI=OFF \
        -DCRYPTOGRAPHY=ON \
        -DCRYPTOGRAPHY_IMPLEMENTATION=OpenSSL && \
    make -j $(nproc) install


WORKDIR /root/repos/ThunderNanoServices/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_TYPE=DEBUG \
        -DPLUGIN_BLUETOOTH=OFF \
    	-DPLUGIN_BLUETOOTHREMOTECONTROL=OFF \
    	-DPLUGIN_COBALT=OFF \
    	-DPLUGIN_COMMANDER=OFF \
    	-DPLUGIN_COMPOSITOR=OFF \
    	-DPLUGIN_PROCESSCONTAINERS=OFF \
    	-DPLUGIN_DISPLAYINFO=OFF \
    	-DPLUGIN_DSRESOLUTION=OFF \
    	-DPLUGIN_DHCPSERVER=ON \
    	-DPLUGIN_DIALSERVER=OFF \
    	-DPLUGIN_DICTIONARY=OFF \
    	-DPLUGIN_IOCONNECTOR=OFF \
    	-DPLUGIN_INPUTSWITCH=OFF \
    	-DPLUGIN_FIRMWARECONTROL=OFF \
    	-DPLUGIN_FRONTPANEL=OFF \
    	-DPLUGIN_PROCESSMONITOR=OFF \
    	-DPLUGIN_NETWORKCONTROL=ON \
    	-DPLUGIN_PLAYERINFO=OFF \
    	-DPLUGIN_POWER=ON \
    	-DPLUGIN_REMOTECONTROL=OFF \
    	-DPLUGIN_RESOURCEMONITOR=ON \
    	-DPLUGIN_RTSPCLIENT=OFF \
    	-DPLUGIN_SECURESHELLSERVER=OFF \
    	-DPLUGIN_STREAMER=OFF \
    	-DPLUGIN_SNAPSHOT=OFF \
    	-DPLUGIN_SPARK=OFF \
    	-DPLUGIN_SYSTEMCOMMANDS=OFF \
    	-DPLUGIN_TIMESYNC=ON \
    	-DPLUGIN_VOLUMECONTROL=OFF \
    	-DPLUGIN_WEBKITBROWSER=OFF \
    	-DPLUGIN_WEBPA=OFF \
    	-DPLUGIN_WEBPROXY=OFF \
    	-DPLUGIN_WEBSERVER=ON \
    	-DPLUGIN_WEBSHELL=OFF \
    	-DPLUGIN_WIFICONTROL=OFF \
    	-DPLUGIN_FILETRANSFER=OFF \
    	-DPLUGIN_DTV=OFF && \
    make -j $(nproc) install

WORKDIR /root/