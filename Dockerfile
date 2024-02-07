FROM ruby:3-alpine

ENV TERM=linux
ENV PS1 "\n\n>> redirectly \W \$ "

RUN apk --no-cache add build-base

RUN gem install redirectly -v 0.2.0

WORKDIR /app
EXPOSE 3000

ENTRYPOINT ["redirectly"]
