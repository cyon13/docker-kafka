FROM ubuntu:20.04

#자바 등 기타 프로그램 설치
RUN apt-get -y update &&  apt-get install -y --no-install-recommends \
    vim \
    wget \
    unzip \
    ssh openssh-* \
    net-tools \
    openjdk-8-jdk

#ssh 키 생성
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Kafka 설치
RUN wget https://downloads.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz && \
    tar -xvf kafka_2.13-3.1.0.tgz && \
    mv kafka_2.13-3.1.0 /usr/local/kafka && \
    rm kafka_2.13-3.1.0.tgz


# 환경변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    KAFKA_HOME=/usr/local/kafka 
ENV PATH=$PATH:$JAVA_HOME/bin:$KAFKA_HOME/bin \
    KAFKA_CONF_DIR=$KAFKA_HOME/config
    
RUN echo 'export KAFKA_HOME=$KAFKA_HOME' >> ~/.bashrc && \
    echo 'export KAFKA_CONF_DIR=$KAFKA_CONF_DIR' >> ~/.bashrc && \
    echo 'export KAFKA_HEAP_OPTS="-Xmx512m -Xms512m"' >> ~/.bashrc && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin:$KAFKA_HOME/bin' >> ~/.bashrc && \
    chown -R $USER:$USER $KAFKA_HOME


# 설정파일 복사(zookeeper)
COPY config/server.properties $KAFKA_CONF_DIR/server.properties
RUN mkdir -p /usr/local/kafka/logs

# 초기 실행파일 복사
COPY start.sh /usr/local/kafka/start.sh

RUN mkdir /var/run/sshd

WORKDIR $KAFKA_HOME

EXPOSE 22


CMD ["bash","start.sh"]
