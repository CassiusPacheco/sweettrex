FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y libicu-dev libxml2 libcurl3 libbsd0

RUN apt-get update && \
    apt-get install -y libmysqlclient20 libmysqlclient-dev && \
    rm -r /var/lib/apt/lists/*;

WORKDIR /vapor

ADD .build/release/Run /vapor
ADD .build/release/libCHTTP.so /usr/lib
ADD .build/release/libCSQLite.so /usr/lib
ADD /libs/libswiftCore.so /usr/lib
ADD /libs/libFoundation.so /usr/lib
ADD /libs/libswiftGlibc.so /usr/lib
ADD /libs/libdispatch.so /usr/lib
COPY /Config /vapor/Config

EXPOSE 8080

ENTRYPOINT ["/vapor/Run"]