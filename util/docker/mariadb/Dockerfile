FROM mariadb:11.8.3

# Switch to root for setup.
USER root

# Install runtime dependencies + config tweaks in single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libjemalloc2 \
    pwgen \
    tzdata \
    xz-utils \
    zstd \
  && mkdir -p /etc/mysql/mariadb.conf.d \
  && printf "[mariadb]\nhost-cache-size=0\nskip-name-resolve\n" \
    > /etc/mysql/mariadb.conf.d/05-skipcache.cnf \
  && find /etc/mysql/ -name '*.cnf' -exec sed -i \
    -e '/^bind-address/d' \
    -e '/^log_error/s/^/#/' \
    -e '/^user[[:space:]]*=/s/^/#/' {} + \
  && chmod 755 /var/run/mysqld \
  && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
  && rm -rf /var/lib/apt/lists/*

# Copy configs and init scripts.
COPY ./config/db.cnf.tmpl /etc/mysql/db.cnf.tmpl
COPY ./initdb/ /docker-entrypoint-initdb.d/

# Switch back to mysql user.
USER mysql
