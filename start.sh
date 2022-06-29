#!/bin/bash

SOURCED=false && [ "$0" = "$BASH_SOURCE" ] || SOURCED=true

if ! $SOURCED; then
  echo "Bash Strict Mode is on: http://redsymbol.net/articles/unofficial-bash-strict-mode/"
  set -euo pipefail
  IFS=$'\n\t'
fi

readonly GIT_REPO="https://github.com/wufpack00/macos-setup.git"
readonly INSTALL_DIR="/tmp/setupmac-$RANDOM"

function install-xcode-cli() {
  local installPath=$(xcode-select -p)

  if [ -d "$installPath" ] ; then
    echo "Command line tools installed at $installPath"
  else
    echo "==========================================="
    echo "Installing Apple's command line tools"
    echo "==========================================="
    xcode-select --install
  fi
}

function install-rosetta() {
  echo "==========================================="
  echo "Installing Rosetta"
  echo "==========================================="
  /usr/sbin/softwareupdate --install-rosetta
}

function install-pip() {
  echo "==========================================="
  echo "Installing pip"
  echo "==========================================="

  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py

  pip --version
}

function install-ansible() {
  echo "==========================================="
  echo "Installing Ansible"
  echo "==========================================="

  sudo pip3 install --ignore-installed ansible

  ansible --version
}


function clone-repo() {
  echo "==========================================="
  echo "Cloning repo into $INSTALL_DIR"
  echo "==========================================="

  git clone "$GIT_REPO" "$INSTALL_DIR"

  if [ ! -d "$INSTALL_DIR" ]; then
      echo "failed to find git repo."
      echo "git cloned failed"
      exit 1
  else
      cd "$INSTALL_DIR" 
  fi
}

function execute-playbook() {
  echo "==========================================="
  echo "Executing playbook"
  echo "==========================================="

  ansible-galaxy install -r requirements.yml
  ansible-playbook --ask-become-pass site.yml --verbose
}

function cleanup() {
  echo "==========================================="
  echo "Removing $INSTALL_DIR"
  echo "==========================================="

  rm -Rfv "$INSTALL_DIR"
}

function main() {
  install-xcode-cli
  install-pip
  install-ansible
  clone-repo
  execute-playbook
  cleanup

  echo "Done."
  exit 0
}

main "$@"
