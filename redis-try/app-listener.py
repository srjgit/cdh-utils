import redis
import sys
import threading

HOST = 'mycdh-node-d1.xyz.com'
r = redis.StrictRedis(host=HOST, port=6379, db=0)


class Listener(threading.Thread):
    def __init__(self, r, channels):
        threading.Thread.__init__(self)
        self.redis = r
        self.pubsub = self.redis.pubsub()
        self.pubsub.subscribe(channels)

    def work(self, item):
        print item['channel'], ":", item['data']

    def run(self):
        for item in self.pubsub.listen():
            if item['data'] == 'JOBDONE':
                self.pubsub.unsubscribe()
                print self, 'unsubscribing Listener'
                break
            self.work(item)

if __name__ == "__main__":
    client = Listener(r, ['testq'])
    client.start()
