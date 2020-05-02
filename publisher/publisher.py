import argparse
import json
import logging
import time
import tweepy
from kafka import KafkaProducer

class MyStreamListener(tweepy.StreamListener):

    def __init__(self, topic, producer):
        super().__init__()
        self.topic = topic.replace(' ', '-')
        self.producer = producer

    def on_status(self, status):
        print(status.text)
        self.producer.send(self.topic, status.text)

def create_argparse():
    parser = argparse.ArgumentParser()
    parser.add_argument('keywords', help='twitter keywords to search for', type=str)
    return parser

def create_kafka_producer(brokers):
    return KafkaProducer(bootstrap_servers=brokers,
                         value_serializer=lambda x: x.encode())

def create_tweepy_client(fp='tokens.json'):
    tokens = json.load(open(fp, 'r'))
    auth = tweepy.OAuthHandler(tokens['consumer_key'], tokens['consumer_secret'])
    auth.set_access_token(tokens['access_token'], tokens['access_token_secret'])
    api = tweepy.API(auth)
    return api

def main():
    parser = create_argparse()
    args = parser.parse_args()
    topic = args.keywords
    brokers = ['192.168.1.3:80']
    producer = create_kafka_producer(brokers)
    Listener = MyStreamListener(topic, producer)
    api = create_tweepy_client()

    myStream = tweepy.Stream(auth=api.auth, listener=Listener)
    myStream.filter(track=[topic])
    return

logger = logging.basicConfig(filename='logs/publisher.log',
                             level=logging.DEBUG,
                             format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                             )
if __name__ == '__main__':
    main()