FROM ruby:2.2.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
COPY resource /opt/resource
RUN bundle install
RUN gem build *.gemspec && gem install *.gem --no-document
