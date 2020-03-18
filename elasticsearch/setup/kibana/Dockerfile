FROM debian:10 as debian

ENV DEBIAN_FRONTEND noninteractive
ENV ES_JAVA_OPTS="-Xms1024m -Xmx1024m" ELASTIC_USERNAME=elastic ELASTIC_PASSWORD=prosper

RUN apt-get update && \
apt-get install -y --fix-missing apt-transport-https nginx apache2-utils wget gnupg2 && \
rm -rf /var/lib/apt/lists/*

RUN cd $HOME

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update -y && apt-get -y install unzip procps curl nano lsof sudo

FROM openjdk:11 as java
COPY --from=debian . .

RUN apt-get -y install kibana

FROM java as kibana
COPY --from=java . .

RUN update-rc.d kibana defaults 95 10

RUN chown -R kibana /usr/share/kibana/*

COPY kibana.yml /etc/kibana/kibana.yml

RUN mkdir -p /opt/kibana

RUN usermod -aG sudo kibana

RUN echo "kibana:prosper" | chpasswd

WORKDIR /opt/kibana/
COPY . /opt/kibana/

RUN chmod -R 755 /opt/kibana/*

ENV HOME=/usr/share/kibana

EXPOSE 5601

CMD ["./setup.sh"]
