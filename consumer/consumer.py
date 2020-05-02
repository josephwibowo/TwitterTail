# import pyspark
# from pyspark import SparkContext
# sc = SparkContext()
from kafka import KafkaConsumer

brokers = ['localhost:32774', 'localhost:32775', 'localhost:32776']
consumer = KafkaConsumer('topic_1',
                         bootstrap_servers=brokers,
                         auto_offset_reset='earliest',
                         enable_auto_commit=True,
                         group_id='test',
                         value_deserializer=lambda x: x.decode('utf-8')
                         )
for msg in consumer:
    print(msg)