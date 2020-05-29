# https://www.docker.elastic.co/
FROM logstash:7.7.0

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json

COPY config/logstash.yml /usr/share/logstash/config/logstash.yml
COPY pipeline/ /usr/share/logstash/pipeline/