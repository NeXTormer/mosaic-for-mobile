#!/bin/bash

ciff_name="$1"
lucene_name="$2"
codec="${3:-[CODEC]}"

cd ../lucene-ciff/target/appassembler/bin/
./CiffImporter /Users/felix/Developer/OWS/owstestandroidnative/app/src/main/assets/resources/$2/$1 /Users/felix/Developer/OWS/owstestandroidnative/app/src/main/assets/lucene/$2/ $3

# java -jar lucene-ciff.jar ../resources/$2/$1 ../lucene/$2/ $3