FROM debian:10
COPY stuff /stuff

RUN apt-get update && apt-get -y upgrade && \
  apt-get -y install --no-install-recommends -o APT::Install-Suggests=false \
  libedit2 libmagic1 mime-support libargon2-1 ucf libpcre2-8-0 libssl1.1 libxml2 \
  libsodium23 libncurses6 psmisc libcurl4 libxslt1.1 libtool autoconf automake \
  libpcre2-dev libssl-dev shtool libtool alien libaio1 procps ca-certificates && \
  cd /stuff && dpkg -i *.deb && alien -i oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
  alien -i oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm && \
  cd pthreads && make clean && phpize && ./configure && make && make install && \
  export ORACLE_HOME=/usr/lib/oracle/12.2/client64 && \
  export C_INCLUDE_PATH=/usr/include/oracle/12.2/client64 && \
  cd /stuff/pdo_oci && make clean && phpize && ./configure && make && make install && \
  echo "extension=pthreads.so" > /etc/php/7.3-zts/mods-available/pthreads.ini && \
  ln -s /etc/php/7.3-zts/mods-available/pthreads.ini /etc/php/7.3-zts/cli/conf.d/30-pthreads.ini && \
  echo "extension=pdo_oci.so" > /etc/php/7.3-zts/mods-available/pdo_oci.ini && \
  ln -s /etc/php/7.3-zts/mods-available/pdo_oci.ini /etc/php/7.3-zts/cli/conf.d/30-pdo_oci.ini && \
  echo '/usr/lib/oracle/12.2/client64/lib' > /etc/ld.so.conf.d/oracle.conf && \
  rm -rf /stuff && apt-get remove -y --purge build-essential cpp \
  linux-libc-dev oracle-instantclient12.2-devel libssl-dev perl bsdmainutils &&  \
  apt-get autoremove -y --purge && apt-get clean && \
  rm -rf /var/lib/apt/lists/* && rm -rf /usr/share/man/
