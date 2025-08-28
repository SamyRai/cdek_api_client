FROM ruby:3.3.3-slim-bullseye

RUN apt-get update && apt-get install -y build-essential

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock *.gemspec ./
COPY lib ./lib
RUN bundle install

COPY . .

CMD ["bin/rspec"]
