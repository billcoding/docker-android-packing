FROM alpine as builder

LABEL Maintainer="billcoding <bill07wang@gmail.com>"
LABEL Description="The Docker Android Packing Dockerfile"

# apk update package
RUN apk update

# apk add Node.js NPM jdk package
RUN apk add unzip nodejs npm openjdk11-jre

# download Android command line tools
RUN wget -O /tmp/commandlinetools-linux_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# mkdir deploy dir
RUN mkdir -p /opt/android

# unzip command line tools
RUN unzip -d /opt/android /tmp/commandlinetools-linux_latest.zip

# configurate PATH
RUN export PATH=$PATH:/opt/android/cmdline-tools/bin

# configurate sdkmanager alias
RUN alias sdkmanager='sdkmanager --sdk_root=/opt/android/sdk'

# accept all android licenses
RUN yes|/opt/android/cmdline-tools/bin/sdkmanager --sdk_root=/opt/android/sdk --licenses

# see the sdkmanager version
RUN /opt/android/cmdline-tools/bin/sdkmanager --sdk_root=/opt/android/sdk --version

# download apktool
RUN wget -O /tmp/apktool_2.7.0.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.7.0.jar

# mkdir apktool dir
RUN mkdir -p /opt/apktool

# copy apktool.jar
RUN cp -rf /tmp/apktool_2.7.0.jar /opt/apktool

# configurate apktool alias
RUN alias apktool='java -jar /opt/apktool/apktool_2.7.0.jar'

# show the apktool version
RUN java -jar /opt/apktool/apktool_2.7.0.jar --version

# download minio client
RUN wget -O /tmp/mc https://dl.min.io/client/mc/release/linux-amd64/mc

# mkdir minio dir
RUN mkdir -p /opt/minio/bin

# copy mc
RUN cp -rf /tmp/mc /opt/minio/bin

# chmod +x mc
RUN chmod +x /opt/minio/bin/mc

# configurate PATH
RUN export PATH=$PATH:/opt/minio/bin

# show mc version
RUN /opt/minio/bin/mc --version

# finally delete tmp files
RUN rm -rf /tmp/*