#!/bin/bash

# remote_debug: Copies binary to target and executes gdbserver

####################################################################################################
# Constants
####################################################################################################

VSCODE_WS="$1"
SSH_REMOTE="$2"
GDBPORT="$3"

APP="guessing_game"
TARGET_ARCH="armv7-unknown-linux-gnueabihf"
BUILD_BIN_FILE="${VSCODE_WS}/target/${TARGET_ARCH}/debug/${APP}"

TARGET_USER="pi"
TARGET_PASSWORD="raspberry"
TARGET_BIN_DIR="/tmp/vscode/debug"
TARGET_CWD="/home/$TARGET_USER"
TARGET_BIN_FILE="$TARGET_BIN_DIR/$APP"

####################################################################################################
# Functions
####################################################################################################

function log() {
  local reset='\033[0m'

  local color

  case $1 in
  success) color='\033[0;32m' ;;
  warning) color='\033[1;33m' ;;
  error) color='\033[0;31m' ;;
  info) color='\033[0;34m' ;;
  *) color=$reset
  esac

  echo -e "$color$2$reset"
}

####################################################################################################
# Main
####################################################################################################

log info "\nChecking for sshpass installation..."

which sshpass > /dev/null

if [ $? -ne 0 ]; then
    sudo apt install -y sshpass
fi

log info "\nStopping current gdbserver instance, if it exists..."

sshpass -p "$TARGET_PASSWORD" ssh "$TARGET_USER@$SSH_REMOTE" "killall gdbserver $APP; mkdir -p $TARGET_BIN_DIR"

log info "\nCopying cross-compiled binary to target..."

if ! sshpass -p "$TARGET_PASSWORD" scp "$BUILD_BIN_FILE" "$TARGET_USER@$SSH_REMOTE:$TARGET_BIN_DIR"; then
    exit 1
fi

log info "\nExecuting gdbserver on target..."

sshpass -p "$TARGET_PASSWORD" ssh -f "$TARGET_USER@$SSH_REMOTE" "sh -c 'cd $TARGET_CWD; nohup gdbserver *:$GDBPORT $TARGET_BIN_FILE > /dev/null 2>&1 &'"
