FROM debian:stable-20230612 as builder

LABEL Maintainer="billcoding <bill07wang@gmail.com>"
LABEL Description="The Docker Android Packing Dockerfile based on Debian 12"

RUN apt update && apt install -y wget unzip nodejs npm openjdk-17-jre-headless

# android command line tools
ARG SDKMANAGER="sdkmanager --sdk_root=/opt/android/sdk"

RUN wget -O /tmp/commandlinetools-linux_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
mkdir -p /opt/android && \
unzip -d /opt/android /tmp/commandlinetools-linux_latest.zip

ENV PATH=$PATH:/opt/android/cmdline-tools/bin
RUN yes|$SDKMANAGER --licenses

# apktool
RUN wget -O /tmp/apktool_2.7.0.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.7.0.jar && \
mkdir -p /opt/apktool && \
cp -rf /tmp/apktool_2.7.0.jar /opt/apktool

# download minio client
RUN wget -O /tmp/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
mkdir -p /opt/minio/bin && \
cp -rf /tmp/mc /opt/minio/bin && \
chmod +x /opt/minio/bin/mc

ENV PATH=$PATH:/opt/minio/bin

# finally delete tmp files
RUN rm -rf /tmp/*