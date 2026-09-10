#!/bin/bash

SESSION="default"

tmux has-session -t "$SESSION" 2>/dev/null
if [ $? -eq 0 ]; then
    tmux attach -t "$SESSION"
    exit 0
fi

tmux new-session -d -s "$SESSION" -n main
tmux attach -t "$SESSION"

