#!/usr/bin/env python

import sys

# compute using get-median-phone-length.py
mean_phone_length = 0.07

for line in sys.stdin:
  (startstr, endstr, predword, rest) = line.split("\t", 3)
  start = float(startstr)
  end = float(endstr)
  l = end - start
  norml = mean_phone_length * len(predword)
  sil = l - norml
  sys.stdout.write('%s\t%s\t%f\t%s\t%s' % (startstr, endstr, sil, predword, rest))
