# Use a lightweight Alpine Linux with OpenJDK
FROM alpine:3.18

ARG JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV PATH=$JMETER_BIN:$PATH

# Install utilities
RUN apk add --no-cache openjdk11-jre curl tar bash

# Download and Install JMeter
RUN mkdir -p /opt && \
    curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/jmeter.tgz && \
    tar -xvf /tmp/jmeter.tgz -C /opt && \
    rm /tmp/jmeter.tgz

# Set working directory
WORKDIR /jmeter

# Entrypoint to run jmeter
ENTRYPOINT ["jmeter"]
