FROM ruby:2.7.6-slim@sha256:d7c357a4e8108266c1e238333448643d8a6d5ec9813ca2a9377c5e59bb59c572 as ruby-base

# RUN groupadd --gid 1000 bbfh \
#     && useradd --home-dir /home/bbfh --create-home --uid 1000 \
#         --gid 1000 --shell /bin/sh --skel /dev/null bbfh
#
# USER bbfh

WORKDIR /work

RUN apt-get update \
  && apt-get install -y libpq-dev shared-mime-info \
  && rm -rf /var/lib/api/lists/*

RUN gem install bundler:2.3.9

FROM ruby-base AS dev-environment

RUN apt-get update \
  && apt-get install -y git gcc make \
  && rm -rf /var/lib/api/lists/*

FROM bbfh_dev:latest AS with-gems-and-assets

# Don't use the cache from here on
ARG CACHE_BUSTER

COPY . .

ENV RAILS_ENV=production

RUN bundle config set --local deployment 'true' && bundle install

RUN bundle exec rake assets:precompile

FROM ruby-base AS final

ENV RAILS_ENV=production
RUN bundle config set --local deployment 'true'
COPY . .
COPY --from=with-gems-and-assets /work/vendor/bundle /work/vendor/bundle
COPY --from=with-gems-and-assets /work/public /work/public
