#!/usr/bin/env python

from sys import argv
from Levenshtein import editops

fh1 = open(argv[1])
fh2 = open(argv[2])

str1 = fh1.read()
str2 = fh2.read()

eops = editops(str1, str2)

stash = {
    str1: { 'i': 0, 'l': 0 },
    str2: { 'i': 0, 'l': 0 },
}
def get_line(offset, text):
  global stash
  stashed = stash[text]
  i = stashed['i']
  line = stashed['l']

  while i < offset:
    if text[i] == "\n":
      line = line + 1
    i = i + 1
  while i > offset:
    i = i - 1
    if text[i] == "\n":
      line = line - 1

  stashed['i'] = i
  stashed['l'] = line

  return line

i1 = 0
i2 = 0
line_edits = 0
line_start = 0
while i1 < len(str1):
  c1 = str1[i1]

  eop = None
  while len(eops) > 0 and i1 >= eops[0][1]:
    eop = eops.pop(0)
    if i1 > eop[1]:
      sys.stderr.write("warning: decreasing ops in source file: (%s %d %d)\n" % eop)
    line_edits = line_edits + 1

  if eop != None:
    i2 = eop[2]

  if c1 == "\n":
    line_len = i1 - line_start
    match = 1 - line_edits / line_len if line_len > 0 else 0
    print("%f\t%d\t%d" % (match, 1+get_line(i1, str1), 1+get_line(i2, str2)))
    line_start = i1
    line_edits = 0

  i1 = i1 + 1

  if eop == None:
    i2 = i2 + 1
