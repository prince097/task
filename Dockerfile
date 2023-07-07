# Use Ubuntu as the base OS
FROM ubuntu:latest

# Set environment variables
ENV ES_VERSION=7.10.2
ENV ES_HOME=/usr/share/elasticsearch
ENV ES_DATA=/var/lib/elasticsearch
ENV ES_LOGS=/var/log/elasticsearch

# Install dependencies
RUN apt-get update && apt-get install -y wget openjdk-11-jdk curl

# Install gosu
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu

# Create a new user and group for Elasticsearch
RUN groupadd -g 1000 elasticsearch && \
    useradd -u 1000 -g elasticsearch -s /bin/bash -m elasticsearch

# Download and install Elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    rm elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    mv elasticsearch-${ES_VERSION} ${ES_HOME}

# Copy the entrypoint script
COPY docker-entrypoint.sh /

# Set the working directory
WORKDIR ${ES_HOME}

# Create Elasticsearch data and log directories
RUN mkdir -p ${ES_DATA} ${ES_LOGS} && \
    chown -R elasticsearch:elasticsearch ${ES_DATA} ${ES_LOGS}

# Set ownership and permissions
RUN chown -R elasticsearch:elasticsearch ${ES_HOME} ${ES_DATA} ${ES_LOGS}

# Set the data and log directories as volumes
VOLUME ${ES_DATA}
VOLUME ${ES_LOGS}

# Expose the default Elasticsearch port
EXPOSE 9200

# Start Elasticsearch
CMD ["/docker-entrypoint.sh"]
