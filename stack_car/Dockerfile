FROM CHANGEME/base:latest

ADD ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ops/env.conf /etc/nginx/main.d/env.conf

RUN gem install bundler -v CHANGEME # Add the BUNDLED WITH version listed at the bottom of the Gemfile.lock
COPY --chown=app . $APP_HOME
RUN /sbin/setuser app bash -l -c "set -x && \
  (bundle check || bundle install) && \
  bundle exec rake assets:clobber assets:precompile DATABASE_ADAPTER=nulldb && \
  mv /home/app/webapp/public/assets /home/app/webapp/public/assets-new && \
  mv /home/app/webapp/public/packs /home/app/webapp/public/packs-new"

RUN bash -l -c "set -x && \
  rm -f /etc/service/nginx/down"

CMD ["/sbin/my_init"]
