#!/usr/bin/env python
import os
import sys
import re

SEARCH_STRING = sys.argv[1]
if not SEARCH_STRING:
    sys.exit()

for line in sys.stdin:
    #print 'looking for %s in %s'%(SEARCH_STRING, line)
    #if SEARCH_STRING in line.split():
    m = re.search(SEARCH_STRING, line)
    if m:
        #print os.environ["map_input_file"]
        print line

