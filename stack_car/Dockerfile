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
                                              vim \
                                              wget \
                                              yarn \
                                              zip 

ARG FIREFOX_VERSION=58.0.2
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
   && rm -rf /opt/firefox \
   && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
   && rm /tmp/firefox.tar.bz2 \
   && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
   && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox
ARG GK_VERSION=v0.19.1
RUN wget --no-verbose -O /tmp/geckodriver.tar.gz http://github.com/mozilla/geckodriver/releases/download/$GK_VERSION/geckodriver-$GK_VERSION-linux64.tar.gz \
   && rm -rf /opt/geckodriver \
   && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
   && rm /tmp/geckodriver.tar.gz \
   && mv /opt/geckodriver /opt/geckodriver-$GK_VERSION \
   && chmod 755 /opt/geckodriver-$GK_VERSION \
   && ln -fs /opt/geckodriver-$GK_VERSION /usr/bin/geckodriver
RUN apt-get install libdbus-glib-1-2
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
RUN mkdir -p /dams_derivatives && \
      chown -R app:app /dams_derivatives
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
# Uncomment if developing Bulkrax within this application
# COPY --chown=1001:1001 $APP_PATH/vendor/engines/bulkrax /app/samvera/hyrax-webapp/vendor/engines/bulkrax
RUN bundle install --jobs "$(nproc)"

COPY stack_car/kakadu /usr/share/kakadu
COPY --chown=1001:1001 $APP_PATH /app/samvera/hyrax-webapp
COPY --chown=1001:1001 $APP_PATH/config/environments/production.rb /app/samvera/hyrax-webapp/config/environments/production.rb

ARG SETTINGS__BULKRAX__ENABLED="true"
RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb bundle exec rake assets:precompile

ENTRYPOINT ["/app/samvera/hyrax-webapp/stack_car/ops/entrypoint.sh"]

FROM hycruz-base as hycruz-worker
ENV MALLOC_ARENA_MAX=2
ENTRYPOINT ["/bin/bash", "/app/samvera/hyrax-webapp/stack_car/ops/worker.sh"]
