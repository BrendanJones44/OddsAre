FROM ruby:2.3.4
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list

# As suggested by a user, for some people this line works instead of the first one. Use whichever works for your case
# RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list


RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list

RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /odds-are-app
WORKDIR /odds-are-app
COPY Gemfile /odds-are-app/Gemfile
COPY Gemfile.lock /odds-are-app/Gemfile.lock
RUN bundle install
COPY . /odds-are-app
