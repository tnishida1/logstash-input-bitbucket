FROM docker.elastic.co/logstash/logstash:6.5.4

USER root

RUN yum update -y

USER logstash
ENV PATH=$PATH:/usr/share/logstash/vendor/jruby/bin/
RUN gem install bundler

COPY --chown=logstash:logstash . /usr/share/logstash/plugins/logstash-input-bitbucket

WORKDIR /usr/share/logstash/plugins/logstash-input-bitbucket
RUN bundler install
RUN gem build /usr/share/logstash/plugins/logstash-input-bitbucket/logstash-input-bitbucket.gemspec

WORKDIR /usr/share/logstash
RUN logstash-plugin install /usr/share/logstash/plugins/logstash-input-bitbucket/logstash-input-bitbucket-*.gem
