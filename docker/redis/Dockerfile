FROM redis:alpine

LABEL Maintainer="Bill Yang <bill.yang@live.ca>" Description="Redis docker based on redis:alpine"

# timezone
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 6397

CMD ["sh", "-c", "rm -f /data/dump.rdb && redis-server"]  # disable persistence
