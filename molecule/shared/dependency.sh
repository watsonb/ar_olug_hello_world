#!/bin/bash

pymgit -f -s -r molecule/shared/requirements.yml && \
ansible-galaxy collection install -r molecule/shared/collections.yml -p molecule/resources/collections --force
