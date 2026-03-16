FROM ruby:3.0.1

RUN wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn 
WORKDIR /manyoo-rails-task
COPY Gemfile /manyoo-rails-task/Gemfile
COPY Gemfile.lock /manyoo-rails-task/Gemfile.lock
RUN gem install nokogiri --platform=ruby
RUN bundle config set force_ruby_platform true
RUN bundle install
COPY . /manyoo-rails-task

# Precompile assets for production
RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile

# Run every time the container is started.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# rails s Execution.
CMD ["rails", "server", "-b", "0.0.0.0"]
