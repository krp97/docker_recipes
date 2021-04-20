FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update --yes 
RUN apt-get install -qq software-properties-common build-essential wget python3 python3-pip zlib1g-dev git --yes
