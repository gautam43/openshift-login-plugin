# This Dockerfile is intended for use by openshift/ci-operator config files defined
# in openshift/release for v4.x prow based PR CI jobs

FROM quay.io/openshift/origin-jenkins-agent-maven:v4.0 AS builder
WORKDIR /java/src/github.com/openshift/jenkins-login-plugin
COPY . .
USER 0
RUN export PATH=/opt/rh/rh-maven35/root/usr/bin:$PATH && mvn clean package

FROM quay.io/openshift/origin-jenkins:v4.0
RUN rm /opt/openshift/plugins/openshift-login.jpi
COPY --from=builder /java/src/github.com/openshift/jenkins-login-plugin/target/openshift-login.hpi /opt/openshift/plugins
RUN mv /opt/openshift/plugins/openshift-login.hpi /opt/openshift/plugins/openshift-login.jpi
USER 0
RUN yum install -y xorg-x11-server-Xvfb gtk2-devel gtk3-devel libnotify-devel GConf2 nss libXScrnSaver alsa-lib
RUN yum install curl -y

RUN yum module install nodejs:10 -y

RUN yum install scl-utils -y

