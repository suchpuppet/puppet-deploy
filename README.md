# deploy

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with deploy](#setup)
    * [What deploy affects](#what-deploy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with deploy](#beginning-with-deploy)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module contains tasks for deploying Puppet environments, including R10k deploy, clearing environment cache, and generating types for a desired environment.  The module also contains a plan for doing all 3 of the above in order.

## Setup

### What deploy affects

The tasks in this module are intended for a system running puppetserver >= 5.0.0 with R10k installed.

This module does not:

* Install puppet or puppetserver packages
* Install or configure r10k

### Setup Requirements

To use this module you must already have:

* puppetserver installed and the service running
* r10k installed and configured to be able to access your control repo
* puppet-agent package installed

### Beginning with deploy

To use the tasks in this module, simply include this module in your Boltdir/Puppetfile and install the module:
```
bolt puppetfile install
```

## Usage

To deploy environment production: `bolt plan run deploy::r10k environment=production --nodes <nodes> --run-as root`

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc.

Contributors:
* Scott Brimhall
