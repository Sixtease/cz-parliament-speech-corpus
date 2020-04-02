#!/usr/bin/env python

''' expect .recout files on stdin and output the median phone length '''

import numpy as np
import sys

lengths = []

for line in sys.stdin:
  (startstr, endstr, word) = line.split()
  start = float(startstr)
  end   = float( endstr )
  l = end - start
  n = len(word)
  lengths.append(l / n)

print(np.median(lengths))
