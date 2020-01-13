FROM ubuntu:bionic as builder
RUN apt update -y && apt upgrade -y 
RUN apt install curl python3 python3-pip -y
RUN pip3 install awscli