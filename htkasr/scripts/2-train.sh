#!/bin/bash

evadevi.pl

cp hmms/{phones,score} ../data/hmms/
cat hmms/{macros,hmmdefs} > ../data/hmms/hmmmodel
