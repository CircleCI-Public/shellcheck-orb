#!/bin/sh
find $DIRPATH -not -path $EXCLUDE -type f -name $PATTERN | \ 
    xargs shellcheck --external-sources | \
    tee -a $OUTPUT