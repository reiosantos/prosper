FROM debian:10

ENV DEBIAN_FRONTEND noninteractive
ENV ES_JAVA_OPTS="-Xms1024m -Xmx1024m" ELASTIC_USERNAME=elastic ELASTIC_PASSWORD=elastic

RUN apt-get update && \
apt-get install -y --fix-missing apt-transport-https nginx apache2-utils wget gnupg2 && \
rm -rf /var/lib/apt/lists/*

# Install JDK 13
RUN mkdir /opt/jdk && cd /opt/jdk
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/13.0.1+9/cec27d702aa74d5a8630c65ae61e4305/jdk-13.0.1_linux-x64_bin.tar.gz

RUN tar -zxf jdk-13.0.1_linux-x64_bin.tar.gz -C /opt/jdk
RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk-13.0.1/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-13.0.1/bin/javac 100
RUN update-alternatives --display java && java -version

RUN cd $HOME

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update  -y && apt-get -y install procps curl nano lsof elasticsearch

RUN update-rc.d elasticsearch defaults 95 10

RUN chown -R elasticsearch /usr/share/elasticsearch/*

RUN mkdir -p /opt/elastic

RUN apt-get install sudo unzip -y

RUN usermod -aG sudo elasticsearch

RUN echo "elasticsearch:prosper" | chpasswd

WORKDIR /opt/elastic/
COPY . /opt/elastic/

RUN chmod -R 755 /opt/elastic/*

ENV HOME=/usr/share/elasticsearch

EXPOSE 9200 9300

CMD ["./setup.sh"]
