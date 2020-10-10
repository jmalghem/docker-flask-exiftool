FROM python:3-alpine
MAINTAINER Julien Malghem <jmalghem@gmail.com>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apk add --no-cache wget perl make
COPY requirements.txt /usr/src/app/

RUN pip3 install --no-cache-dir -r requirements.txt

RUN mkdir /tmp/install && \
    cd /tmp/install && \
    wget https://exiftool.org/Image-ExifTool-12.06.tar.gz -O /tmp/install/Image-ExifTool-12.06.tar.gz && \
    tar -xvzf Image-ExifTool-12.06.tar.gz && \
    cd Image-ExifTool-12.06 && \
    perl Makefile.PL && \
    make && make test; make install && \
    cd /tmp/install && \
    rm -rf /tmp/install/Image-ExifTool-12.06*

RUN cd /tmp/install && \
    wget https://github.com/smarnach/pyexiftool/tarball/master -O /tmp/install/pyexiftool.tar.gz && \
    tar -zxvf pyexiftool.tar.gz && \ 
    cd smarnach-pyexiftool-* && \
    python3 setup.py install && \
    cd /tmp/install && \
    rm -rf /tmp/install/smarnach-pyexiftool-*

COPY . /usr/src/app

EXPOSE 8080

ENTRYPOINT ["python3"]

CMD ["-m", "swagger_server"]
