#!/usr/bin/env bash
if [ $# -eq 0 ]; then
  echo "$0 [pubsub | srvcli | act]"
  exit 1
fi

export PYTHONPATH="./.venv/lib/python3.12/site-packages/:${PYTHONPATH}"
source ./.venv/bin/activate
source ./install/setup.bash
ros2 launch ./config/${1}.launch.py
