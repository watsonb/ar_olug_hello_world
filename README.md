# ar_hello_world

Just a little "Hello World" role for testing purposes.  Primarily used to test
that AWX and other tools are able to successfully `ansible-galaxy install` this
role and apply it.

Run with verbose output (i.e., `-v`) to debug the host's standard output.

## Build Status

|Branch|Status|
|:---:|:---:|
|develop|[![Build Status](https://jenkins.kiewit.com/buildStatus/icon?job=ar_hello_world/develop)](https://jenkins.kiewit.com/job/ar_hello_world/develop)|
|master|[![Build Status](https://jenkins.kiewit.com/buildStatus/icon?job=ar_hello_world/master)](https://jenkins.kiewit.com/job/ar_hello_world/master)|

## Current Version

![Version](https://img.shields.io/badge/version-v1.0.1-blue.svg)

See [VERSION](./VERSION.md) for notes/history.

## Requirements

N/A

## Role Variables

All over-writable variables used in this role are defined in [defaults/main.yml](./defaults/main.yml).

You can override the variables in any standard Ansible-way (e.g. group_vars,
host_vars, playbook variables, command-line, etc.).

The variables in this role include:

|Name|Required|Default|Choices|Comments|
|:---|:------:|:------|:------|:-------|
|hello_world_msg|no|'Hello, World!'| |The message to echo on a host|

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in
regards to parameters that may need to be set for other roles, or variables
that are used from other roles.

|Role|Description|Version|
|:---|:----------|:-----:|
| | | |

## Example Playbook

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

```yaml
- name: Role with defaults
  hosts: servers
  gather_facts: true
  tasks:

    - name: apply ar_hello_world role
      import_role:
        name: ar_hello_world
```

```yaml
- name: Role with over-rides
  hosts: servers
  gather_facts: true
  tasks:

    - name: apply ar_hello_world role
      import_role:
        name: ar_hello_world
      vars:
        hello_world_msg: 'Goodbye, World!'
```

> **Note:** Form (1) is preferred in playbooks as it keeps the playbooks reusable.
> Ideally, you should be over-riding variable values via group/host vars in an
> inventory.
>
> **Note:** You must gather facts (`gather_facts: true`) for `ansible_system` to
> detect Windows vs. Linux hosts.

## License

TBD

## Author Information

|Author|E-mail|
|:---|:---|
|Ben Watson|Benjamin.Watson@kiewit.com|

## Role Development Information

### Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

### Git SCM

Please refer to the .gitignore file and update accordingly depending on your
development environment, etc.  The particular file was generated at
[gitignore.io](https://www.gitignore.io/) and contains settings for the
following:

* Ansible
* Python
* Vim
* Eclipse
* IntelliJ IDEA
* Linux
* Windows

### Versioning

Please update [VERSION.md](./VERSION.md) as you release new versions of your
role and try to abide by
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

### Self-contained

Please try to keep this role as self-contained as possible such that it may be
simply installed (e.g. `ansible-galaxy install`) and applied as part of a
playbook.

### Documentation

This role leverages [ansible-mdgen](https://murphypetercl.github.io/ansible-mdgen/)
to generate "pretty" documentation for this role.  As such, this role contains a
`mkdocs` configuration at the root of the project folder and a `docs/`
sub-folder.

Please consult the `ansible-mdgen` documentation for advanced usage, but as a
primer for getting started, do the following:

```bash
cd <path_to_root_of_role>
pip install -r docs/requirements.txt
ansible-mdgen .

# view your documentation live as you author role
mkdocs serve

# build your docs for distribution/hosting
# note, the resulting site/ folder is ignored via Python .gitignore rules
mkdocs build
```
