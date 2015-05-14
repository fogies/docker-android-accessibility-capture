# Android development environment for ubuntu precise (12.04 LTS) (i386).
# version 0.0.1

# Start with ubuntu 12.04 (i386).
FROM toopher/ubuntu-i386:12.04

MAINTAINER tracer0tong <yuriy.leonychev@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Update packages
RUN apt-get -y update

# First, install add-apt-repository and bzip2
RUN apt-get -y install python-software-properties bzip2

# Add oracle-jdk7 to repositories
RUN add-apt-repository ppa:webupd8team/java

# Make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

# Update apt
RUN apt-get update

# Install oracle-jdk7
RUN apt-get -y install oracle-java7-installer:i386

# Install android sdk
RUN wget http://dl.google.com/android/android-sdk_r23-linux.tgz
RUN tar -xvzf android-sdk_r23-linux.tgz
RUN mv android-sdk-linux /usr/local/android-sdk

# Install apache ant
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz
RUN tar -xvzf apache-ant-1.8.4-bin.tar.gz
RUN mv apache-ant-1.8.4 /usr/local/apache-ant

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Add ant to PATH
ENV ANT_HOME /usr/local/apache-ant
ENV PATH $PATH:$ANT_HOME/bin

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Remove compressed files.
RUN cd /; rm android-sdk_r23-linux.tgz && rm apache-ant-1.8.4-bin.tar.gz

# Some preparation before update
RUN chown -R root:root /usr/local/android-sdk/

# Install latest android tools and system image.
RUN echo "y" | android update sdk --filter tools --no-ui --force
RUN echo "y" | android update sdk --filter platform-tools --no-ui --force
RUN echo "y" | android update sdk --filter platform --no-ui --force
RUN echo "y" | android update sdk --filter build-tools-21.0.1 --no-ui -a
RUN echo "y" | android update sdk --filter sys-img-x86-android-18 --no-ui -a
RUN echo "y" | android update sdk --filter sys-img-x86-android-19 --no-ui -a
RUN echo "y" | android update sdk --filter sys-img-x86-android-21 --no-ui -a

# Set up and run emulator
RUN echo "n" | android create avd -f -n test -t android-19

# Update ADB
RUN echo "y" | android update adb
RUN adb kill-server
RUN adb start-server

# Create fake keymap file
RUN mkdir /usr/local/android-sdk/tools/keymaps
RUN touch /usr/local/android-sdk/tools/keymaps/en-us
