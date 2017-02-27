FROM ruby:2.2.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install bosh-init
RUN \
  wget https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.101-linux-amd64 && \
  mv bosh-init-* /usr/local/bin/bosh-init && \
  chmod a+x /usr/local/bin/bosh-init

COPY . /usr/src/app
COPY resource /opt/resource
RUN bundle install
RUN gem build *.gemspec && gem install *.gem --no-document
