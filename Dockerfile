FROM ruby:2.7.2

ARG RAILS_ENV
ARG NODE_ENV

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV RAILS_ENV ${RAILS_ENV:-development}

RUN apt-get update \
  && apt-get install -y curl git locales tzdata \
  && apt-get install -y build-essential libpq-dev patch ruby-dev zlib1g-dev liblzma-dev \
  && apt-get install -y libcurl4 libcurl4-openssl-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y sudo

RUN locale-gen ja_JP.UTF-8 \
  && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p /myapp
WORKDIR /myapp
COPY . /myapp

# puma socket file
RUN mkdir -p /myapp/tmp/sockets

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle update --bundler && bundle install

CMD ["bundle", "exec", "puma", "-e", "production", "-C", "config/puma.rb"]

