#!/bin/sh
readarray ORBSOURCE < $TARGET_FILEPATH

i=0
until [ $i -eq ${#ORBSOURCE[@]} ]; do
    LINE="${ORBSOURCE[$i]}"
    echo "$LINE"
    if echo "$LINE" | grep "command: |"; then
    script=true; FILE="$i.sh"; j=1; mkdir -p "$OUTPUT_DIR"
    while "$script"; do
        SCRIPTLINE="${ORBSOURCE[$i+$j]}"

        # if this is true, we are still in the command block
        if [[ ! $(echo "$SCRIPTLINE" | grep -e "name: " \
        -e "shell: " -e "environment: " -e "background: " \
        -e "working_directory: " -e "no_output_timeout: " \
        -e "when: ") ]]; then
        echo "$SCRIPTLINE" >> "$OUTPUT_DIR/$FILE"
        ((j++))
        continue
        else
        script=false
        i=$(( i + j ))
        fi
    done

    else
    ((i++))
    fi
done