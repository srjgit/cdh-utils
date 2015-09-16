import redis
import sys

HOST = 'mycdh-node-d1.xyz.com'
r = redis.StrictRedis(host=HOST, port=6379, db=0)

def complete(r,prefix,count):
    results = []
    rangelen = 50 # This is not random, try to get replies < MTU size
    start = r.zrank('compl',prefix)    

    if not start:
         return []

    while (len(results) != count):         
         range = r.zrange('compl',start,start+rangelen-1)         
         start += rangelen
         if not range or len(range) == 0:
             break
         for entry in range:
             minlen = min(len(entry),len(prefix))             
             if entry[0:minlen] != prefix[0:minlen]:                
                count = len(results)
                break              
             if entry[-1] == "*" and len(results) != count:                 
                results.append(entry[0:-1])
     
    return results

def autoComplete(searchName):
    print complete(r,searchName,50)

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        searchName = sys.argv[1] 
    else:
        searchName = 'AUTO'

    autoComplete(searchName)
