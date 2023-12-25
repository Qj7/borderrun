# ARG RUBY_VERSION=3.1.2
# ARG BUNDELR_VERSION=2.4.19

# FROM ruby:${RUBY_VERSION}-alpine AS builder

# RUN apk update
# RUN apk upgrade
# RUN apk add --no-cache --update build-base bash bash-completion libffi-dev tzdata postgresql-client postgresql-dev nodejs

# ENV APP_HOME /app
# RUN mkdir -p $APP_HOME
# WORKDIR $APP_HOME

# COPY . $APP_HOME

# RUN gem install bundler -v "${BUNDELR_VERSION}"
# RUN bundle install


# ENV BUNDLE_PATH $APP_HOME/vendor
# ENV GEM_HOME $APP_HOME/vendor
# ENV PATH $GEM_HOME/bin:/app/bin:$PATH


#COPY config/database.deploy.yml config/database.yml

# RUN bundle exec rake assets:clobber
# RUN rails assets:precompile

# RUN rm -rf $APP_HOME/node_modules
# RUN rm -rf $APP_HOME/tmp/*

# COPY entrypoint.sh /usr/bin/

# RUN chmod +x /usr/bin/entrypoint.sh

# WORKDIR $APP_HOME

# EXPOSE 3000

# ENTRYPOINT ["entrypoint.sh"]
# CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]




# ------------------

FROM ruby:3.1.2

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v '2.4.19' && \
    bundle install --jobs 4

# Copy the application code
COPY . .

RUN rails assets:precompile

# Expose ports
EXPOSE 3000

# Set the entrypoint command
# CMD ["rails", "server", "-b", "127.0.0.1"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]