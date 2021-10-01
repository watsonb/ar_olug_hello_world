# Test Requirements

- This role leverages [Molecule](http://molecule.readthedocs.io/en/stable-1.25/) 
  for local and CI testing
- Automated CI/CD platform is Jenkins (see [Jenkinsfile](./Jenkinsfile))

Currently the included Jenkins CI pipeline only tests the `default` scenario,
which are Linux instances.  To test Windows instances:

```bash
molecule create --scenario-name windows_create
molecule converge --scenario-name windows_converge
molecule idempotence --scenario-name windows_converge
molecule verify --scenario-name windows_converge
molecule destroy --scenario-name windows_converge
```

## Molecule Configuration

- This role customizes `molecule` by leveraging a custom Git cloning tool named
  `pymgit`.  You can install `pymgit` as follows:

  ```bash
  pip install pymgit
  ```

  Ensure pymgit is installed in the same Python environment as `ansible` and
  `molecule`.  The `molecule dependency` task uses `pymgit` to clone custom
  delegated drivers and an Ansible inventory.

- Review the [molecule.yml](default/molecule.yml) and adjust accordingly
- Rename the `no_prepare.yml` and/or `no_requirements.yml` files in the default
  scenario (and add them to other scenarios) if your test needs to prepare hosts
  or needs to download/install Ansible roles as part of the test.

### Molecule base Dependencies

In order for our custom molecule testing method to work, you should include the
follow roles in each of your `molecule` scenario's requirements.yml file at a
minimum.  Your scenario may need to include more roles if the role under test
has additional dependencies.

|Role|Description|Version|Source|
|:---|:---|:---:|:---|
|ae_molecule|A default molecule inventory|master|ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ae_molecule|
|ap_molecule|Custom delegated drivers for VMWare and Azure|master|ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ap_molecule|
|ansible-config_encoder_filters|Converts YAML to other formats (e.g. YAML, XML, JSON, etc.)|master|https://github.com/jtyr/ansible-config_encoder_filters.git|
|ar_azure_instance|Ansible role to spin up a VM instance on Azure|master|ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ar_azure_instance|
|ar_vmware_instance|Ansible role to spin up a VM instance on VMWare|master|ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ar_vmware_instance|

Please consult [default/requirements.yml](default/requirements.yml) as an example
of requirements.yml formatting and see the example below:

```yaml
- src: ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ae_molecule
  version: master
  dest: molecule/resources
  name: inventory
  tags: []

- src: ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ap_molecule
  version: master
  dest: molecule/resources
  name: playbooks
  tags: []

- src: https://github.com/jtyr/ansible-config_encoder_filters.git
  version: master
  dest: molecule/resources/roles
  tags: []

- src: ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ar_vmware_instance
  version: master
  dest: molecule/resources/roles
  tags: []

- src: ssh://KiewitCorp@vs-ssh.visualstudio.com:22/DefaultCollection/Ansible/_ssh/ar_azure_instance
  version: master
  dest: molecule/resources/roles
  tags: []
```

## Jenkins Configuration

- Jenkins is configured with an `ansible` labeled slave
  - You can change the label to another slave, but ensure the slave has the
    following:
    - `ansible` executor has a Python virtual environment with the following required
      python modules: see [molecule_pip_requirements.txt](molecule_pip_requirements.txt)
    - `ansible` executor has Docker installed and executor-user can use Docker
    - `ansible` executor has `molecule` and `pymgit` installed
- Jenkins (server) configures a tool named `venv_ansible` to the root path of 
  the Python virtual environment containing above listed required modules

## Molecule Container Images

The following are "stock" Ubuntu/CentOS images you can use

```yaml
platforms:
  - name: ubuntu-1804-bionic
    image: "ubuntu:18.04"
    groups:
      - role_template
  - name: ubuntu-1604-xenial
    image: "ubuntu:16.04"
    groups:
      - role_template
  - name: centos-7
    image: "centos:7"
    groups:
      - role_template
```

Some SystemD-enabled container images that may be worth looking into as
"standard" images:

[reference](https://framagit.org/rg/ansible-role-template/blob/master/molecule/default/molecule.yml)

```yaml
platforms:
  # RHEL
  - name: molecule-template-rhel6
    image: registry.access.redhat.com/rhel6:6.9
  - name: molecule-template-rhel7
    image: registry.access.redhat.com/rhel7:7.4
    privileged: True                                         # required for systemd
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"                   # required for systemd
    command: /usr/sbin/init                                  # required for systemd
  # CentOS
  - name: molecule-template-centos7
    image: centos:7
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    command: /usr/sbin/init
  # Debian
  - name: molecule-template-debian9-systemd
    image: jrei/systemd-debian:9
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    command: /lib/systemd/systemd
  - name: molecule-template-debian10-systemd
    image: jrei/systemd-debian:10
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    command: /lib/systemd/systemd
  # Ubuntu
  - name: molecule-template-ubuntu1604-systemd
    image: solita/ubuntu-systemd:16.04
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    command: /bin/bash -c exec /sbin/init --log-target=journal 3>&1
  - name: molecule-template-ubuntu1804-systemd
    image: solita/ubuntu-systemd:18.04
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    command: /bin/bash -c exec /sbin/init --log-target=journal 3>&1
```
