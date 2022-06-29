To setup run the following command :
```
curl -s https://raw.githubusercontent.com/wufpack00/macos-setup/master/start.sh | /bin/bash
```

This will install `xcode-select` followed by `pip` and then `ansible`.
It will then perform a git clone of this repository and execute master playbook to install multiple apps and make configuration changes.

To execute the playbook directly:
```
ansible-playbook site.yml --ask-become-pass -v
```

sudo pip3 install --upgrade pip
pip install ansible
ansible-galaxy install --force  -r requirements.yml
