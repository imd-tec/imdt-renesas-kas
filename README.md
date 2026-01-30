# IMDT Renesas Yocto Build Environment

This repository provides a Docker-based build environment for building Yocto images for IMDT Renesas boards (V2H-SBC, V2N-SBC).

## Quick Start

```
./env.sh
```

This builds a Docker image with all Yocto dependencies and drops you into an interactive shell. From there, use `kas menu` to configure and build your image.

## What env.sh Does

The script:

1. Builds a Docker image based on Ubuntu 20.04 with all Yocto build dependencies
2. Creates a container user matching your host UID/GID for correct file permissions
3. Mounts your current directory as the workspace
4. Mounts your SSH keys (`~/.ssh`) for repository access
5. Mounts your git configuration (`~/.gitconfig`) for commit operations

## Advanced Configuration

### Shared Downloads Directory

Yocto downloads source tarballs during the build which can take significant time and disk space. To share downloads across multiple builds or workspaces, set `DL_MIRROR_DIR` before running the script:

```
export DL_MIRROR_DIR=/path/to/shared/downloads
./env.sh
```

This mounts the specified directory at `~/downloads` inside the container. Configure your kas/Yocto build to use this location for `DL_DIR` to avoid re-downloading sources.