# IMDT Renesas Yocto Build Environment

This repository provides KAS configuration files for building Yocto images for IMDT Renesas boards (V2H-SBC, V2N-SBC) using `kas-container`.

## Quick Start

Source the environment setup script, then build or open a shell:

```bash
source env.sh -v
kas-container build <config>.yml
```

Or to interactively configure and build:

```bash
source env.sh
kas-container shell <config>.yml
```

## What env.sh Does

The script sets up environment variables for `kas-container`:

1. Sets `KAS_WORK_DIR` to your current working directory
2. Adds `kas-container` to your `PATH`
3. Sets the kas container image version (`KAS_IMAGE_VERSION`)
4. Optionally configures a custom build directory (`-b <path>`)

## Usage

### Building an Image

```bash
source env.sh
kas-container build default.yml
```

### Interactive Shell

Drop into a shell inside the kas container with the build environment configured:

```bash
source env.sh
kas-container shell default.yml
```

From there you can run BitBake commands directly.

### Menu Configuration

```bash
source env.sh
kas-container menu
```

## env.sh Options

```
-b, --build     Set build directory path (default: build)
-v, --verbose   Print environment variables
-h, --help      Print usage
```
