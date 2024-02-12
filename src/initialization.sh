#!/bin/bash

set -e -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

export HOMEDIR=`pwd`
export SOURCEDIR=$HOMEDIR/src

sudo apt update
sudo apt install ros-$ROS_DISTRO-rviz2 -y

source /opt/ros/$ROS_DISTRO/setup.bash

# install linux pkgs
sudo apt-get install libpthread-stubs0-dev
sudo apt install ros-$ROS_DISTRO-perception-pcl -y
sudo apt install ros-$ROS_DISTRO-composition -y

####################################
### ros2 deiver for AWR1843BOOST ###
####################################
cd /home/ws

git clone https://github.com/kimsooyoung/mmwave_ti_ros.git

# pkg build
colcon build --symlink-install --packages-select serial
source install/local_setup.bash

colcon build --symlink-install --packages-select ti_mmwave_ros2_interfaces
source install/local_setup.bash

colcon build --symlink-install --packages-select ti_mmwave_ros2_pkg
source install/local_setup.bash

# For this package, pcl common is required, But don't be afraid, ROS Installing contains PCL
colcon build --symlink-install --packages-select ti_mmwave_ros2_examples
source install/local_setup.bash
####################################
####################################
####################################

echo "source install/local_setup.bash" >> ~/.bashrc
echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc