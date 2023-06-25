FROM alpine:3.18 as builder

LABEL Maintainer="billcoding <bill07wang@gmail.com>"
LABEL Description="The Docker Android Packing Dockerfile"

# apk update package
RUN apk update

# apk add Node.js NPM jdk package
RUN apk add unzip nodejs npm openjdk11-jre

# android command line tools
ARG SDKMANAGER="sdkmanager --sdk_root=/opt/android/sdk"
RUN echo $SDKMANAGER
RUN wget -O /tmp/commandlinetools-linux_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN mkdir -p /opt/android
RUN unzip -d /opt/android /tmp/commandlinetools-linux_latest.zip
ENV PATH=$PATH:/opt/android/cmdline-tools/bin
RUN yes|$SDKMANAGER --licenses

# apktool
RUN wget -O /tmp/apktool_2.7.0.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.7.0.jar
RUN mkdir -p /opt/apktool
RUN cp -rf /tmp/apktool_2.7.0.jar /opt/apktool

# download minio client
RUN wget -O /tmp/mc https://dl.min.io/client/mc/release/linux-amd64/mc
RUN mkdir -p /opt/minio/bin
RUN cp -rf /tmp/mc /opt/minio/bin
RUN chmod +x /opt/minio/bin/mc
ENV PATH=$PATH:/opt/minio/bin

# finally delete tmp files
RUN rm -rf /tmp/*