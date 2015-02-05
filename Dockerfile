FROM dockerrails_base

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN bundle install --without development test
RUN rake assets:precompile RAILS_ENV=production

CMD ["puma", "-C", "config/puma.rb", "-e", "production"]
