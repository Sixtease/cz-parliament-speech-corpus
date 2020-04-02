#!/usr/bin/env python

"""
first argument is file with one split point in seconds per line
on stdin is alignment data in tab-separated format
  audio start
  audio end
  guessed silence length
  predicted word
  gold-standard word
  gold-standard line number
  prediction - gold-standard match

output are tab-separated fields:
  audio start
  audio end
  starting line
  end line
"""

import sys
import numpy as np

splitsfn = sys.argv[1]
splitsfh = open(splitsfn, 'r', encoding = 'UTF-8')
splits = [float(x.rstrip()) for x in splitsfh.readlines()]
splitsfh.close()

def init_block():
  return {
    'matches': [],
    'startlineno': None,
  }

def process_block(block):
  if block['matches'][ 0] < 0.5:
    sys.stderr.write('discard: unreliable start\n')
    return
  if block['matches'][-1] < 0.5:
    sys.stderr.write('discard: unreliable end\n')
    return
  if np.mean(block['matches']) < 0.7:
    sys.stderr.write('discard: unreliable mean\n')
    return
  if len(block['matches']) < 5:
    sys.stderr.write('discard: too few words\n')
    return
  l = block['audioend'] - block['audiostart']
  if l < 12:
    sys.stderr.write('discard: too short\n')
    return
  if l > 30:
    sys.stderr.write('discard: too long\n')
    return
  sys.stderr.write('accept\n')
  print("%f\t%f\t%s\t%s" % (block['audiostart'], block['audioend'], block['startlineno'], block['endlineno']))

start_line = 0
start_time = 0
spliti = 0
block = init_block()
last_split = 0
for line in sys.stdin:
  (startstr, endstr, slenstr, predword, goldword, goldlinenostr, matchstr) = line.rstrip().split("\t")

  if block['startlineno'] == None:
    block['startlineno'] = goldlinenostr
    block['audiostart'] = last_split

  match = float(matchstr)
  block['matches'].append(match)
  block['endlineno'] = goldlinenostr

  end = float(endstr)
  if spliti < len(splits) and end > splits[spliti]:
    block['audioend'] = end
    last_split = splits[spliti]
    process_block(block)
    block = init_block()
    spliti = spliti + 1

process_block(block)
