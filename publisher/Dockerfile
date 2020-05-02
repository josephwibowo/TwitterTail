FROM python:3.7-alpine

COPY requirements.txt /

RUN pip install -r /requirements.txt
RUN mkdir /usr/publisher

COPY publisher.py /usr/publisher
WORKDIR /usr/publisher

CMD ["python", "publisher.py"]