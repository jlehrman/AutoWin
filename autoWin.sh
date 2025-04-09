#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
VARS="$DIR/.vars"
LOG="$DIR/autoWin.log"
PYTHON="$DIR/.venv/bin/python"
TODAY=$(date +%m/%d/%Y)

echo "running" >> "$LOG"
if [ -f "$VARS" ]; then 
    LAST_RUN=$(grep "DATE" "$VARS" | cut -d':' -f2 | xargs)
    if [[ -z "$LAST_RUN" || "$LAST_RUN" != "$TODAY" ]]; then
        NAME=$(grep "NAME" "$VARS" | cut -d':' -f2 | xargs)
        EMAIL=$(grep "EMAIL" "$VARS" | cut -d':' -f2 | xargs)
        LOC=$(grep "LOC" "$VARS" | cut -d':' -f2 | xargs)
        CONF=$(grep "CONF" "$VARS" | cut -d':' -f2 | xargs)
        "$PYTHON" "$DIR/autoWin.py" "$NAME" "$EMAIL" "$LOC" "$CONF" >> "$LOG" 2>&1
        LAST_RUN=$TODAY
        echo -e "DATE:$LAST_RUN\nNAME:$NAME\nEMAIL:$EMAIL\nLOC:$LOC\nCONF:$CONF" > "$VARS"
    else
        echo "Already ran today" >> "$LOG"
    fi
fi