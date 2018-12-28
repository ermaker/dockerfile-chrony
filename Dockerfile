FROM alpine
MAINTAINER Minwoo Lee <ermaker@gmail.com>
HEALTHCHECK --interval=3s --retries=20 CMD chronyc -h localhost tracking

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update --no-cache chrony confd@testing

# Redirect squid access logs to stdout
RUN ln -sf /dev/stdout /var/log/chrony/tracking.log && \
    ln -sf /dev/stdout /var/log/chrony/statistics.log && \
    ln -sf /dev/stdout /var/log/chrony/measurements.log

COPY src/etc/confd /etc/confd
COPY src/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["chronyd","-d"]
