FROM ruby:3.0.3

RUN set -x \
  && curl -fsSL https://deb.nodesource.com/setup_17.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs \
    build-essential \
    libpq-dev libxslt-dev libxml2-dev \
    nodejs yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/yum/*

# set environment variables
ENV LANG C.UTF-8
ENV APP_ROOT /app
ENV BUNDLE_JOBS 4
ENV BUNDLER_VERSION 2.2.32

# working on app root
RUN mkdir /app
WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle -v
RUN bundle install
COPY . $APP_ROOT

# execute script after build container
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]