#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM java:7-jre

ENV ES_PKG_NAME elasticsearch-1.5.0

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD /config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml
ADD /config/ik /elasticsearch/config/ik
# Install Admin UI
RUN ["/elasticsearch/bin/plugin", "--install", "mobz/elasticsearch-head"]
# Install JDBC River
RUN ["/elasticsearch/bin/plugin", "--install", "jdbc","--url" ,"https://github.com/caofb/elasticsearch/blob/master/plugins/elasticsearch-river-jdbc-1.5.0.5-plugin-all.zip?raw=true"]
# Install Ik
RUN ["/elasticsearch/bin/plugin", "--install", "analysis-ik ","--url" ,"https://github.com/caofb/elasticsearch/blob/master/plugins/elasticsearch-analysis-ik-1.3.0.zip?raw=true"]


# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
