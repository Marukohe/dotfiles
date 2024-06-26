#!/bin/bash
# Install some useful tools
# This shell script needs sudo

# Common developer tools
echo "-----> Installing git vim build-essential cmake..."
apt-get install git vim build-essential cmake -y

# Modern Unix tools
echo "-----> Installing bat delta duf fd-find tldr..."
apt-get install bat delta duf fd-find tldr -y

echo "👌 Carry on with env setup!"
