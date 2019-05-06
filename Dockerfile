FROM ruby:2.3.4

RUN apt-get update -qq
# Debian Jessie mirrors were removed
RUN echo "deb http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list

# Debian Jessie mirrors were removed
RUN set -eux; \
        # Jessie's apt doesn't support [check-valid-until=no] so we have to use this instead
        apt-get -o Acquire::Check-Valid-Until=false update; \
RUN app-get install -y build-essential libpq-dev nodejs
RUN mkdir /odds-are-app
WORKDIR /odds-are-app
COPY Gemfile /odds-are-app/Gemfile
COPY Gemfile.lock /odds-are-app/Gemfile.lock
RUN bundle install
COPY . /odds-are-app
