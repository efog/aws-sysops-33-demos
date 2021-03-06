FROM efog/ubuntu-bionic-awscli:1
RUN apt install bash -y
ARG KEY_ID
ARG SECRET_ACCESS_KEY
ARG REGION=us-east-1
ENV AWS_SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
ENV AWS_ACCESS_KEY_ID=${KEY_ID}
ENV AWS_DEFAULT_REGION=${REGION}
CMD ["/bin/bash"]