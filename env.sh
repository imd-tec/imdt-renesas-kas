#!/bin/bash

# Get the directory where this script lives (for Docker build context)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Workspace is the caller's directory (where KAS files are)
WORKSPACE_DIR="$PWD"

# 1. Capture host user info
USER_NAME=imdt
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Build the image from script's directory (where Dockerfile is)
docker build --build-arg UID=$USER_ID --build-arg GID=$GROUP_ID -t custom-ubuntu:20.04 "$SCRIPT_DIR"
# 2. Define image
IMAGE="custom-ubuntu:20.04"

echo "Launching Ubuntu 20.04 for user: $USER_NAME ($USER_ID:$GROUP_ID)"
eval "$(ssh-agent -s)"

# Optional: set DL_MIRROR_DIR to mount a shared downloads volume
DL_MOUNT=""
if [ -n "${DL_MIRROR_DIR:-}" ]; then
    DL_MOUNT="-v $DL_MIRROR_DIR:/home/$USER_NAME/downloads"
fi

# 3. Run Docker with the captured user info
docker run -it --rm \
    --user $USER_ID:$GROUP_ID \
    -v ~/.ssh:/home/$USER_NAME/.ssh:ro \
    -v ~/.gitconfig:/home/$USER_NAME/.gitconfig:ro \
    -v "$WORKSPACE_DIR":/home/$USER_NAME/workspace \
    $DL_MOUNT \
    -w /home/$USER_NAME/workspace \
    $IMAGE \
    bash -l