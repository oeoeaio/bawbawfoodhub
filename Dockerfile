FROM ruby:2.7.4-slim@sha256:eeea7b32e8670e4a6095690981d6e7cf838bf066449da76bfc1166916e093748 AS ruby-base

# RUN groupadd --gid 1000 bbfh \
#     && useradd --home-dir /home/bbfh --create-home --uid 1000 \
#         --gid 1000 --shell /bin/sh --skel /dev/null bbfh
#
# USER bbfh

WORKDIR /work

RUN apt-get update \
  && apt-get install -y libpq-dev nodejs shared-mime-info \
  && rm -rf /var/lib/api/lists/*

FROM ruby-base AS dev-environment

RUN apt-get update \
  && apt-get install -y build-essential git curl \
  && rm -rf /var/lib/api/lists/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn \
  && rm -rf /var/lib/api/lists/*

FROM dev-environment AS with-gems

COPY . .

RUN bundle install

FROM with-gems AS with-assets

ENV RAILS_ENV=production

RUN bundle exec rake assets:precompile

FROM ruby-base AS final

ENV RAILS_ENV=production

COPY . .
COPY --from=with-gems /usr/local/bundle /usr/local/bundle
COPY --from=with-assets /work/public /work/public
