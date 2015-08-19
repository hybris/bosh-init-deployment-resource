FROM ruby:2.2.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN bundle install
RUN mkdir -p /opt/resource && \
    ln -s $(which bdr_check) /opt/resource/check && \
    ln -s $(which bdr_in) /opt/resource/in && \
    ln -s $(which bdr_out) /opt/resource/out
