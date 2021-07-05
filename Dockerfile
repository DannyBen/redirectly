FROM alpine

ENV BUILD_PACKAGES bash curl curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-etc ruby-io-console libffi-dev zlib-dev
ENV TERM=linux
ENV PS1 "\n\n>> redirectly \W \$ "

RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES

RUN gem install bundler && bundle config --global silence_root_warning 1

RUN gem install redirectly -v 0.1.1

WORKDIR /app

ENTRYPOINT ["redirectly"]