FROM python:3.6.10-slim-buster

ENV FILES=""

COPY . /app

WORKDIR /app

RUN python3 setup.py install 

RUN mkdir /input

RUN mkdir /output

WORKDIR /input

CMD pyan3 ${FILES} > graph.dot && \
    dot -T svg graph.dot > graph.svg