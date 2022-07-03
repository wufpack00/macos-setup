To setup run the following command :

```basn
curl -s https://raw.githubusercontent.com/wufpack00/macos-setup/master/start.sh | /bin/bash
```

This will install Xcode Command Line Tools followed by `pip` and then `ansible`.
It will then perform a git clone of this repository and execute an Ansible playbook to perform the following tasks:

- Install Homebrew along with various packages and casks
- Set up Oh My ZSH config
- Set up VSCode config

To execute the playbook directly:

```bash
ansible-playbook main.yml --ask-become-pass -v
```
