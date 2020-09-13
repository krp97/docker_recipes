FROM ubuntu:18.04
RUN apt-get update --yes
RUN apt-get install build-essential cmake python3 python3-pip zlib1g-dev git --yes 
RUN mkdir -p /root/repos/
WORKDIR /root/repos
RUN git clone https://github.com/rdkcentral/Thunder.git
RUN git clone https://github.com/rdkcentral/ThunderNanoServices.git

# Install the python generators.
RUN mkdir -p /root/repos/Thunder/Tools/build
WORKDIR /root/repos/Thunder/Tools/build 
RUN pip3 install jsonref --quiet
RUN cmake .. && make install

# Build and install the Thunder framework. 
RUN mkdir -p /root/repos/Thunder/build
WORKDIR /root/repos/Thunder/build
RUN cmake .. -DBUILD_TYPE=Debug && make -j$(getconf _NPROCESSORS_ONLN) install

# Build and install the ThunderNanoServices.
RUN mkdir -p /root/repos/ThunderNanoServices/build
WORKDIR /root/repos/ThunderNanoServices/build/
RUN cmake .. -DPLUGIN_BLUETOOTH=OFF \
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
	-DPLUGIN_DTV=OFF \
	-DBUILD_TYPE=DEBUG && make -j$(getconf _NPROCESSORS_ONLN) install

