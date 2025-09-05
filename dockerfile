ARG POSTGRES_VERSION=17
FROM postgres:${POSTGRES_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends locales cron && \
    echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=pt_BR.UTF-8 \
    LC_ALL=pt_BR.UTF-8
    

RUN mkdir -p /var/lib/postgresql/certs

COPY certs/certificado.crt /var/lib/postgresql/certs/certificado.crt
COPY certs/certificado.key /var/lib/postgresql/certs/certificado.key

RUN chmod 600 /var/lib/postgresql/certs/certificado.key \
    && chmod 644 /var/lib/postgresql/certs/certificado.crt \
    && chown postgres:postgres /var/lib/postgresql/certs/*

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD pg_isready -U postgres || exit 1

CMD ["postgres"]
