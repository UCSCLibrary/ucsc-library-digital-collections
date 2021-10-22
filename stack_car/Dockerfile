FROM ruby:2.7.2 as hycruz-base

RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends  \
                                              build-essential \
                                              clamav \
                                              cmake \
                                              curl \
                                              default-libmysqlclient-dev \
                                              ffmpeg \
                                              ghostscript \
                                              git \
                                              libclamav-dev \
                                              libmagickcore-dev \
                                              libpq-dev \
                                              libxml2-dev \
                                              libreoffice \
                                              mariadb-server \
                                              mediainfo \
                                              netcat \
                                              nodejs \
                                              openjdk-11-jre \
                                              perl \
                                              rsync \
                                              tzdata \
                                              unzip \
                                              wget \
                                              yarn \
                                              zip 

RUN mkdir -p /app/fits && \
    cd /app/fits && \
    wget https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip -O fits.zip && \
    unzip fits.zip && \
    rm fits.zip && \
    chmod a+x /app/fits/fits.sh
ENV PATH="${PATH}:/app/fits"
RUN ln -fs /usr/lib/x86_64-linux-gnu/libmediainfo.so.0.0.0 /app/fits/tools/mediainfo/linux/libmediainfo.so.0 && \
  ln -fs /usr/lib/x86_64-linux-gnu/libmediainfo.so.0.0.0 /app/fits/tools/mediainfo/linux/libmediainfo.so.0

RUN addgroup --system --gid 1001 app && \
  adduser --system --ingroup app -u 1001 --shell /bin/sh --home /app app
RUN chown -R app /app
USER app

RUN mkdir -p /app/samvera/hyrax-webapp
WORKDIR /app/samvera/hyrax-webapp

RUN git clone https://github.com/UCSCLibrary/ScoobySnacks.git /app/samvera/hyrax-webapp/scooby_snacks
RUN git clone https://github.com/UCSCLibrary/samvera_hls.git /app/samvera/hyrax-webapp/samvera_hls

#Set the locale to UTF-8 to prevent Bundler to fail when gemspecs contain non ASCII characters
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:/usr/share/kakadu:$PATH
ENV LD_LIBRARY_PATH /usr/share/kakadu:/app/fits/tools/mediainfo/linux

ARG APP_PATH=.
COPY --chown=1001:1001 $APP_PATH/Gemfile* /app/samvera/hyrax-webapp/
RUN bundle install --jobs "$(nproc)"

COPY stack_car/kakadu /usr/share/kakadu
COPY --chown=1001:1001 $APP_PATH /app/samvera/hyrax-webapp
COPY --chown=1001:1001 $APP_PATH/config/environments/production.rb /app/samvera/hyrax-webapp/config/environments/production.rb

ARG SETTINGS__BULKRAX__ENABLED="true"
RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb bundle exec rake assets:precompile

ENTRYPOINT ["/app/samvera/hyrax-webapp/stack_car/ops/entrypoint.sh"]

FROM hycruz-base as hycruz-worker
ENV MALLOC_ARENA_MAX=2
CMD bundle exec sidekiq
