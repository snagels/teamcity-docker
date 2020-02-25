FROM java:8

MAINTAINER Sebastian Nagels <nagels.sebastian@gmail.com>

ENV TEAMCITY_VERSION 2019.2.2
ENV TEAMCITY_DATA_PATH /var/lib/teamcity

# Get and install teamcity
RUN wget -qO- --no-check-certificate https://download.jetbrains.com/teamcity/TeamCity-${TEAMCITY_VERSION}.tar.gz | tar xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" remoteIpHeader=\"x-forwarded-for\" protocolHeader=\"x-forwarded-proto\" portHeader=\"x-forwarded-port\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

# Install perforce
RUN wget ftp://ftp.perforce.com/perforce/r19.2/bin.linux26x86_64/p4 \
	&& chmod +x p4 \
	&& mv p4 /usr/local/bin


COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE  8111

VOLUME /var/lib/teamcity

ENTRYPOINT ["/docker-entrypoint.sh"]
