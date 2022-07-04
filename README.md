To setup run the following command :

```basn
curl -s https://raw.githubusercontent.com/wufpack00/macos-setup/master/start.sh | /bin/bash
```

This will install Xcode Command Line Tools followed by `pip` and then `ansible`.
It will then perform a git clone of this repository and execute an Ansible playbook to perform the following tasks:

- Install Homebrew along with various packages and casks
- Clone my dotfiles and create symlinks to set them up
- Set up Oh My ZSH config
- Set up VSCode config

To execute the playbook directly:

```bash
ansible-playbook main.yml --ask-become-pass -v
```

Steps done manually:
 * First run of iTerm/zsh will configure [powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt
 * Import [Dracula iTerm theme](https://draculatheme.com/iterm): Preferences > Profiles > Colors > Color Presets ...
 * Activate [Dracula Slack theme](https://draculatheme.com/slack)


 References:
 * https://github.com/geerlingguy/mac-dev-playbook