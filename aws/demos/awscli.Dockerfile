FROM ubuntu:bionic as builder
RUN apt update -y && apt upgrade -y 
RUN apt install bash curl python3 python3-pip sudo zsh git -y
RUN useradd -m cliuser && echo "cliuser:cliuser" | chpasswd && adduser cliuser sudo
USER cliuser
RUN pip3 install awscli
RUN export PATH=$PATH:~/.local/bin
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
CMD ["zsh"]