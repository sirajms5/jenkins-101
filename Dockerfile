# latest jenkins plugin
FROM jenkins/jenkins:lts-jdk11
# for java use: FROM jenkins/jenkins:lts-jdk17
# switch to root user
USER root
# update package list and use dependencies for python
RUN apt-get update && apt-get install -y lsb-release python3-pip
# add maven at the end to install maven
# for node.js:
#   RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \ 
#     apt-get install -y nodejs
# to verify node.js installation 
#   RUN node -v && npm -v
# to verify java installation
#   RUN java -version && mvn -version


# Downloads docker's GPG key for verifying package authenticity, and saves it in the docker repository /use/share/keyrings/
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
# This adds Docker's official package repository to the system.
# The command:
#  Detects the CPU architecture dynamically using dpkg --print-architecture.
#  Detects the Linux distribution name dynamically using lsb_release -cs (e.g., bullseye for Debian 11).
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
# Update package list again & install Docker CLI
# apt-get update: Refreshes package sources after adding Docker’s repository.
# apt-get install -y docker-ce-cli: Installs the Docker CLI but not the full Docker Engine.
RUN apt-get update && apt-get install -y docker-ce-cli
# switch back to jenkins user
USER jenkins
# uses jenkins cli to install plugins
# Blue Ocean (1.25.3) – A modern UI for Jenkins Pipelines.
# Docker Workflow (1.28) – Enables Jenkins to run and manage Docker containers in pipelines.
# add maven-plugin:3.12 to add maven plugin
RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"


# in terminal run command:
#   for nodejs: docker build -t myjenkins-node:latest .
#   for java: docker build -t myjenkins-java:latest .

