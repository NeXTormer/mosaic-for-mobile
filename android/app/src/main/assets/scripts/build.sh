#!/bin/bash

export JAVA_HOME=/Users/felix/Library/Java/JavaVirtualMachines/corretto-22.0.2/Contents/Home

export PATH=$PATH:/Users/felix/Developer/OWS/anserini-master/target/appassembler/bin
export PATH=$PATH:/Users/felix/Developer/OWS/ciff-master/target/appassembler/bin



codec="${1:-[CODEC]}"

# try to convert all CIFF files which are not converted yet
for f in ../resources/*/*.ciff*
do
    dir="${f%/*}"
    dir="${dir##*/}"
    f=$(echo $f | sed s:.*/::)
    echo "Checking if $f in $dir is already import..."
    if [ ! -d "../lucene/$dir" ]; then
        echo "Converting CIFF file $f in $dir to Lucene index..."
        d=$(echo $f | sed "s/\..*//")
        echo "Creating directory ../lucene/$dir"
        ./import_index.sh "$f" "$dir"
        echo "Import of $f completed successfully"
    else
        echo "$f is already converted"
    fi
done