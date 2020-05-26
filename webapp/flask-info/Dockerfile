
# pull official base image
FROM python:slim-buster

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_ENV "development"
ENV FLASK_DEBUG True

# install dependencies
RUN apt-get update
RUN apt-get install -y build-essential \
    python3-apt python3-dev python3-pip python3-mysqldb python3-setuptools

RUN pip install --upgrade pip && \
    pip install flask flask-sqlalchemy pymysql docker cryptography

# copy files
COPY __init__.py /opt/webapp/__init__.py
COPY config.py /opt/webapp/config.py
COPY index.py /opt/webapp/index.py
COPY templates /opt/webapp/templates

EXPOSE 5000

# every time the docker run, `python /opt/webapp/index.py` is being called
#ENTRYPOINT [ "python" ] 
CMD [ "python3", "/opt/webapp/index.py" ]