FROM ruby:3-alpine

ENV PS1 "\n\n>> redirectly \W \$ "
RUN apk add --no-cache git build-base

ARG branch=master

WORKDIR /redirectly
RUN git clone --branch $branch --depth 1 https://github.com/DannyBen/redirectly.git .
RUN gem build redirectly.gemspec --output redirectly.gem
RUN gem install redirectly.gem
RUN rm -rf /redirectly

VOLUME /app
WORKDIR /app
EXPOSE 3000

ENTRYPOINT ["redirectly"]