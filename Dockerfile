FROM ruby:2.5.0
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
