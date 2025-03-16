#!/usr/bin/env bash
ROS_DISTRO=jazzy
python3 -m venv .venv --system-site-packages
touch ./.venv/COLCON_IGNORE
source ./.venv/bin/activate
pip install -r requirements.txt

source /opt/ros/${ROS_DISTRO}/setup.bash
colcon build --symlink-install
