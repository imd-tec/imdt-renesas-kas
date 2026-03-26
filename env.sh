# IMDT KAS Build Environment Setup Script
#
# Source this script to set up environment variables for kas-container.
# KAS_WORK_DIR is set to the caller's working directory ($PWD), so build/
# and sources/ will be created there.
#
# Usage:
#   source imdt-renesas-kas/env.sh [OPTIONS]
#   # or
#   cd imdt-renesas-kas && source env.sh [OPTIONS]
#
# Then run:
#   kas-container shell development.yml
#   kas-container build development.yml
#
# Options:
#   -b, --build       Set path build directory (default: build)
#   -v, --verbose     Print environment variables
#   -h, --help        Print usage

# Path build directory
BUILD_DIR="build"

# Flags
USAGE_ENABLED=false
VERBOSE_ENABLED=false

usage()
{
    printf "%b" "Usage: source env.sh [OPTIONS]\n"
    printf "%b" "-b, --build\t\tSet path build directory.\n"
    printf "%b" "-v, --verbose\t\tPrint environment variables.\n"
    printf "%b" "-h, --help\t\tPrint this help.\n"
}

################################################################################
#                                Parse options                                 #
################################################################################

while [ $# -gt 0 ]; do

    SHIFT_PARAMS=1

    case "$1" in
    -b|--build)
        if [ ! $# -lt 2 ]; then
            BUILD_DIR="$2"
            let SHIFT_PARAMS++
        fi
        ;;
    -v|--verbose)
        VERBOSE_ENABLED=true
        ;;
    -h|--help)
        USAGE_ENABLED=true
        ;;
    *)
        USAGE_ENABLED=true
        ;;
    esac

    shift ${SHIFT_PARAMS}
    unset SHIFT_PARAMS
done

################################################################################
#                                 Print usage                                  #
################################################################################

if $USAGE_ENABLED; then
    usage
fi

################################################################################
#                   Find the path of the kas work directory                    #
################################################################################

# KAS_WORK_DIR is the caller's working directory — build/ and sources/
# will be created relative to wherever this script was sourced from.
export KAS_WORK_DIR="$( readlink -f "$PWD" )"

################################################################################
#              Add directory containing 'kas-container' to 'PATH'              #
################################################################################

# Get the directory where this script (and kas-container) lives
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPT_DIR="$( readlink -f "${SCRIPT_DIR}" )"

if [ -f "${SCRIPT_DIR}/kas-container" ]; then

    # Remove any existing occurrences of SCRIPT_DIR from PATH
    PATH="$( echo ${PATH} | sed -re "s#(^|:)${SCRIPT_DIR}(:|$)#\2#g;s#^:##" )"

    # Add to PATH
    PATH="${SCRIPT_DIR}:${PATH}"
    export PATH
else
    echo "Warning: kas-container not found in ${SCRIPT_DIR}"
fi

unset SCRIPT_DIR

################################################################################
#                        Select kas container image version                    #
################################################################################

export KAS_IMAGE_VERSION="${KAS_IMAGE_VERSION:-4.5}"

################################################################################
#                           Set path build directory                           #
################################################################################

if [ "$( basename "${BUILD_DIR}" )" = "${BUILD_DIR}" ]; then

    # Relative name — resolve against KAS_WORK_DIR
    export KAS_BUILD_DIR="$( readlink -f "${KAS_WORK_DIR}/${BUILD_DIR}" )"
else
    if [ "${BUILD_DIR}" != "/" ]; then

        # Absolute path — remove trailing slashes and canonicalize
        BUILD_DIR="$( readlink -f "$( echo "${BUILD_DIR}" | sed -re "s|/+$||" )" )"

        if [ ! -z "${BUILD_DIR}" ]; then
            export KAS_BUILD_DIR="${BUILD_DIR}"
        fi
    fi
fi

################################################################################
#                         Print environment variables                          #
################################################################################

if $VERBOSE_ENABLED; then

    echo "--- IMDT KAS Environment ---"

    if [ -n "${KAS_WORK_DIR-}" ]; then
        echo "KAS_WORK_DIR=${KAS_WORK_DIR}"
    fi

    if [ -n "${KAS_BUILD_DIR-}" ]; then
        echo "KAS_BUILD_DIR=${KAS_BUILD_DIR}"
    fi

    if [ -n "${KAS_IMAGE_VERSION-}" ]; then
        echo "KAS_IMAGE_VERSION=${KAS_IMAGE_VERSION}"
    fi

    if [ -n "${DL_DIR-}" ]; then
        echo "DL_DIR=${DL_DIR}"
    fi

    if [ -n "${SSTATE_DIR-}" ]; then
        echo "SSTATE_DIR=${SSTATE_DIR}"
    fi

    if [ -n "${GITCONFIG_FILE-}" ]; then
        echo "GITCONFIG_FILE=${GITCONFIG_FILE}"
    fi

    if [ -n "${KAS_SSH_DIR-}" ]; then
        echo "KAS_SSH_DIR=${KAS_SSH_DIR}"
    fi

    echo "----------------------------"
fi

# Unset local variables
unset BUILD_DIR
unset USAGE_ENABLED
unset VERBOSE_ENABLED
