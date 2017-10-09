FROM selenium/standalone-chrome:latest

# Maven
RUN wget http://mirrors.viethosting.vn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -xf apache-maven-3.3.9-bin.tar.gz  -C /usr/local

RUN ln -s /usr/local/apache-maven-3.3.9 /usr/local/maven

ENV M2_HOME /usr/local/maven
ENV PATH=${M2_HOME}/bin:${PATH}

# Docker

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update && \
    apt-get install -y docker-ce=17.06.0~ce-0~ubuntu

# Git
RUN apt-get -y install git


USER jenkins

WORKDIR ${WORKSPACE}

# launch container
#ENTRYPOINT ["/bin/bash"]
