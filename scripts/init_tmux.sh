#!/bin/bash

SESSION="default"

tmux has-session -t "$SESSION" 2>/dev/null
if [ $? -eq 0 ]; then
    tmux attach -t "$SESSION"
    exit 0
fi

tmux new-session -d -s "$SESSION" -n main
TL=$(tmux list-panes -t "$SESSION:main" -F '#{pane_id}')

TR=$(tmux split-window -h -p 50 -t "$TL" -P -F '#{pane_id}')

BL=$(tmux split-window -v -p 85 -t "$TL" -P -F '#{pane_id}')

BR=$(tmux split-window -v -p 50 -t "$TR" -P -F '#{pane_id}')

tmux send-keys -t "$TL" 'tclock' C-m
tmux send-keys -t "$BL" 'htop' C-m
tmux send-keys -t "$TR" 'bluetui' C-m
tmux send-keys -t "$BR" 'wiremix' C-m

tmux select-pane -t "$TL"
tmux attach -t "$SESSION"
