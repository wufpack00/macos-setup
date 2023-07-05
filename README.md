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
- Download Alfred workflows

To execute the playbook directly:

```bash
# Prompt for password (when 1password-cli is not installed)
ansible-playbook -K main.yml --limit $(hostname) -v

# Retrieve password from 1password-cli
eval $(op signin --account agilebits.1password.com)
--extra-vars @<(echo ansible_become_pass: $(op item get zxkyxhferscdadhkvni6c55wsy --vault "Private" --format json |jq --raw-output '.fields[] | select (.id=="password").value'))

```

Steps done manually:
 * First run of iTerm/zsh will configure [powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt
 * Import [Dracula iTerm theme](https://draculatheme.com/iterm): Preferences > Profiles > Colors > Color Presets ...
 * Double-click Alfred workflows to import/activate 
 * Double-click Alfred Dracula theme to activate
 * Configure [Dracula Slack theme](https://draculatheme.com/slack)

 Steps to do:
  * template files
 ** .ssh/config file
 ** .sh.local
 ** .gitconfig.local
 * Disable spotlight search / Enable Alfred search
 


 References:
 * https://github.com/geerlingguy/mac-dev-playbook