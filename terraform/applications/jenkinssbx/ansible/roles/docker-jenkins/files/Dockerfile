# See https://github.com/jenkinsci/docker#installing-more-tools

FROM jenkins/jenkins:lts-alpine-jdk17

# create a dir to store the custom Jenkins configurations
USER root
RUN mkdir /jenkins_config
RUN apk add --no-cache figlet python3 py3-pip sshpass
RUN pip3 install pip --upgrade --break-system-packages
RUN pip3 install kubernetes --break-system-packages
RUN pip3 install ansible --break-system-packages
RUN pip3 install jmespath --break-system-packages
RUN pip3 install requests --break-system-packages
RUN pip3 install pyyaml --break-system-packages
RUN ansible-galaxy collection install community.general
RUN ansible-galaxy collection install community.kubernetes
RUN ansible-galaxy collection install community.docker
RUN ansible-galaxy collection install community.aws

RUN chown -R jenkins /jenkins_config
USER jenkins

# Don't run the setup wizard
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"

# install the Jenkins plugins
COPY jenkins_plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# configure Jenkins
ENV CASC_JENKINS_CONFIG /jenkins_config/config_jenkins_as_code.yaml
COPY config_jenkins_as_code.yaml /jenkins_config/config_jenkins_as_code.yaml

# configure jobs
COPY *.groovy /jenkins_config/

# Copy the SSH private key to be utilized by Ansible.
COPY jenkins_ansible_key /jenkins_config/jenkins_ansible_key

# COPY vault.txt /var/jenkins_home/vault.txt

USER root
RUN chown -R jenkins /jenkins_config
RUN chmod 600 /jenkins_config/jenkins_ansible_key

# drop back to the regular jenkins user - good practice
USER jenkins