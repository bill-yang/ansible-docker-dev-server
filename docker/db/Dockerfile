# MySQL docker
FROM mysql:8.0

LABEL Maintainer="Bill Yang <bill.yang@live.ca>" Description="MySQL docker mysql:8.0"
# timezone
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Configure mysql
COPY ./my.cnf  /etc/mysql/conf.d/custom.cnf

EXPOSE 3306
