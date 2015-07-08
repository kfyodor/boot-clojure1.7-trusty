FROM ubuntu:14.04
MAINTAINER Theodore Konukhov <me@thdr.io / https://github.com/konukhov>

RUN sudo apt-get -y install curl wget openssl ca-certificates && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/8u45-b14/server-jre-8u45-linux-x64.tar.gz && \
    mkdir /opt/jdk && \
    tar -zxf server-jre-8u45-linux-x64.tar.gz -C /opt/jdk && \
    update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_45/bin/java 100 && \
    update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_45/bin/javac 100

ENV JAVA_HOME /opt/jdk

RUN wget -O /usr/local/bin/boot "https://github.com/boot-clj/boot/releases/download/2.0.0/boot.sh" \
    | bash && \
    chmod +x /usr/local/bin/boot

ENV BOOT_AS_ROOT yes
ENV BOOT_CLOJURE_VERSION 1.7.0


# Misha's setup for faster startup
# https://github.com/boot-clj/boot/wiki/JVM-Options
ENV BOOT_JVM_OPTIONS "-client -XX:+TieredCompilation"
ENV BOOT_JVM_OPTIONS "$BOOT_JVM_OPTIONS -XX:TieredStopAtLevel=1"
ENV BOOT_JVM_OPTIONS "$BOOT_JVM_OPTIONS -XX:+UseConcMarkSweepGC"
ENV BOOT_JVM_OPTIONS "$BOOT_JVM_OPTIONS -XX:+CMSClassUnloadingEnabled -Xverify:none"

RUN boot web -s doesnt/exist repl -e '(System/exit 0)'

CMD ["boot", "repl"]
