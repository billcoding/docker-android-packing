FROM debian:stable-20230612-slim

LABEL Maintainer="billcoding <bill07wang@gmail.com>"
LABEL Description="The Docker Android Packing Dockerfile based on Debian 12"

RUN apt update && apt install -y wget unzip xz-utils 

RUN wget -O /tmp/node-v18.16.1-linux-x64.tar.xz https://nodejs.org/download/release/latest-v18.x/node-v18.16.1-linux-x64.tar.xz && \
tar xvf /tmp/node-v18.16.1-linux-x64.tar.xz -C /tmp && \
mkdir -p /opt/node && \
mv /tmp/node-v18.16.1-linux-x64 /opt/node/v18.16.1 && \
rm -rf /tmp/node-v18.16.1-linux-x64.tar.xz

ENV PATH=$PATH:/opt/node/v18.16.1/bin

ENV NODE_HOME=/opt/node/v18.16.1

RUN wget -O /tmp/OpenJDK11.tar.gz https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.19%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.19_7.tar.gz && \
tar xvf /tmp/OpenJDK11.tar.gz -C /tmp && \
mkdir -p /opt/jdk && \
mv /tmp/jdk-11.0.19+7 /opt/jdk/openjdk11 && \
rm -rf /tmp/OpenJDK11.tar.gz

ENV PATH=$PATH:/opt/jdk/openjdk11/bin

ENV JAVA_HOME=/opt/jdk/openjdk11

# android command line tools
ARG SDKMANAGER="sdkmanager --sdk_root=/opt/android/sdk"

RUN wget -O /tmp/commandlinetools-linux_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
mkdir -p /opt/android && \
unzip -d /opt/android /tmp/commandlinetools-linux_latest.zip && \
rm -rf /tmp/commandlinetools-linux_latest.zip

ENV PATH=$PATH:/opt/android/cmdline-tools/bin
RUN yes|$SDKMANAGER --licenses

RUN sdkmanager --sdk_root=/opt/android/sdk --install "build-tools;34.0.0-rc3"

ENV ANDROID_HOME=/opt/android/sdk

ENV ANDROID_SDK_BUILD_TOOLS_VERSION=34.0.0-rc3

# apktool
RUN wget -O /tmp/apktool_2.7.0.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.7.0.jar && \
mkdir -p /opt/apktool && \
cp -rf /tmp/apktool_2.7.0.jar /opt/apktool && \
rm -rf /tmp/apktool_2.7.0.jar

ENV APK_TOOL_JAR_FILE=/opt/apktool/apktool_2.7.0.jar

# download minio client
RUN wget -O /tmp/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
mkdir -p /opt/minio/bin && \
cp -rf /tmp/mc /opt/minio/bin && \
chmod +x /opt/minio/bin/mc && \
rm -rf /tmp/mc

ENV PATH=$PATH:/opt/minio/bin

ENV MC_BIN_FILE=/opt/minio/bin/mc