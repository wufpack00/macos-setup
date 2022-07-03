#!/bin/bash

SOURCED=false && [ "$0" = "$BASH_SOURCE" ] || SOURCED=true

if ! $SOURCED; then
  echo "Bash Strict Mode is on: http://redsymbol.net/articles/unofficial-bash-strict-mode/"
  set -euo pipefail
  IFS=$'\n\t'
fi

readonly GIT_REPO="https://github.com/wufpack00/macos-setup.git"
readonly INSTALL_DIR="/tmp/setupmac-$RANDOM"

function create-workdir() {
  echo "==========================================="
  echo "Creating work dir"
  echo "==========================================="
  mkdir "$INSTALL_DIR"
  echo "Directory ${INSTALL_DIR} successfully created"
}

function install-xcode-cli() {
  echo "==========================================="
  echo "Installing Apple's command line tools"
  echo "==========================================="

  local installPath
  installPath=$(xcode-select -p)

  if [ -d "$installPath" ] ; then
    echo "Command line tools installed at $installPath"
  else
    xcode-select --install
    sleep 1
    osascript <<-EOD
	    tell application "System Events"
	      tell process "Install Command Line Developer Tools"
	        keystroke return
	        click button "Agree" of window "License Agreement"
	      end tell
	    end tell
EOD
  fi
}

function install-rosetta() {
  echo "==========================================="
  echo "Installing Rosetta"
  echo "==========================================="

  # save existing state
  OLDIFS=$IFS
  IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"

  # restore IFS to previous state
  IFS=$OLDIFS

  # M1 was first supported in macOS 11
  if [[ ${osvers_major} -ge 11 ]]; then

    # Is this an Apple or Intel processor?
    processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")

    if [[ -n "$processor" ]]; then
      echo "$processor processor installed. No need to install Rosetta."
    else
       # perform non-interactive install if not already installed
      if /usr/bin/pgrep oahd >/dev/null 2>&1; then
          echo "Rosetta is installed and running."
      else
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
      fi
    fi
    else
      echo "Mac is running macOS $osvers_major.$osvers_minor.$osvers_dot_version."
      echo "No need to install Rosetta on this version of macOS."
  fi
}

function upgrade-pip() {
  echo "==========================================="
  echo "Upgrading pip"
  echo "==========================================="
  export PATH="$HOME/Library/Python/3.8/bin:/opt/homebrew/bin:$PATH"
  # should already be installed as part of python
  if [[ ! $(python3 -m pip) ]] ; then
    curl https://bootstrap.pypa.io/get-pip.py -o "${INSTALL_DIR}/get-pip.py"
    python3 "${INSTALL_DIR}/get-pip.py"
  fi
  # upgrade
  python3 -m pip install --upgrade pip
}

# https://docs.python-guide.org/dev/virtualenvs/#lower-level-virtualenv
function create-virtualenv() {
  echo "==========================================="
  echo "Creating virtual environment"
  echo "==========================================="
  cd "$INSTALL_DIR"
  python3 -m venv .venv && source .venv/bin/activate
}

function install-ansible() {
  echo "==========================================="
  echo "Installing Ansible"
  echo "==========================================="

  #sudo pip3 install --ignore-installed ansible
  python3 -m pip install ansible

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
  ansible-playbook --ask-become-pass main.yml -vvv
}

function cleanup() {
  echo "==========================================="
  echo "Removing $INSTALL_DIR"
  echo "==========================================="

  rm -Rf "$INSTALL_DIR"
}

trap cleanup EXIT

function main() {
  create-workdir
  clone-repo
  install-xcode-cli
  install-rosetta
  upgrade-pip
  create-virtualenv
  install-ansible
  execute-playbook
  #cleanup happens automatically due to exit trap

  echo "Done."
  exit 0
}

main "$@"
