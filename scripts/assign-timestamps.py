#!/usr/bin/env python

import sys

goldfn = sys.argv[1]
goldfh = open(goldfn, 'r', encoding = 'UTF-8')
goldlines = goldfh.readlines()
goldfh.close()

predfn = sys.argv[2]
predfh = open(predfn, 'r', encoding = 'UTF-8')
predlines = predfh.readlines()
predfh.close()

for line in sys.stdin:
  (match, predlinenostr, goldlinenostr) = line.split()
  predlinei = int(predlinenostr) - 1
  goldlinei = int(goldlinenostr) - 1
  predline = "\t".join(predlines[predlinei].rstrip().split())
  goldline = goldlines[goldlinei].rstrip()
  print("%s\t%s\t%s\t%s" % (predline, goldline, goldlinenostr, match))
