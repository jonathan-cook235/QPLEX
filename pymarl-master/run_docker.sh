#!/bin/bash
set -x
HASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
WANDB_API_KEY_FILE="WANDB_API_KEY_FILE.txt"
WANDB_API_KEY=$(cat $WANDB_API_KEY_FILE)
GPU=$1
name=${USER}_pymarl_GPU_${GPU}_${HASH}

echo "Launching container named '${name}' on GPU '${GPU}'"
# Launches a docker container using our image, and runs the provided command

if hash nvidia-docker 2>/dev/null; then
  cmd=nvidia-docker
else
  cmd=docker
fi

NV_GPU="$GPU" ${cmd} run --rm \
    -e WANDB_API_KEY=$WANDB_API_KEY \
    -e LANG=C.UTF-8 \
    -e LC_ALL=C.UTF-8 \
    --name $name \
    --user $(id -u) \
    --memory 100g \
    -v $(pwd):/home/jonook/src/pymarl-dev \
    -t pymarl:smacv2 \
    ${@:2}
