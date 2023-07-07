#!/bin/bash
set -e

# Set proper permissions
chown -R elasticsearch:elasticsearch ${ES_HOME} ${ES_DATA} ${ES_LOGS}

# Start Elasticsearch
exec gosu elasticsearch "${ES_HOME}/bin/elasticsearch"
