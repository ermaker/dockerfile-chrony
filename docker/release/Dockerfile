FROM alpine
MAINTAINER Justin Menga <justin.menga@gmail.com>
ARG app_name
LABEL application=${app_name}
HEALTHCHECK --interval=3s --retries=20 CMD chronyc -h localhost tracking

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update --no-cache chrony confd@testing

COPY src/etc/confd /etc/confd
COPY src/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["chronyd","-d","-f","/etc/chrony.conf"]