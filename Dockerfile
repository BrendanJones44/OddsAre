FROM ruby:2.3.4

RUN mkdir /odds-are-app
WORKDIR /odds-are-app
COPY Gemfile /odds-are-app/Gemfile
COPY Gemfile.lock /odds-are-app/Gemfile.lock
RUN bundle install
COPY . /odds-are-app
