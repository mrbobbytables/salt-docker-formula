======
Docker
======
.. image:: https://travis-ci.org/mrbobbytables/salt-docker-formula.svg?branch=master

Formula for managing the install and configuration of both Docker-Engine and Docker-Compose.

Tested with the following platforms:

- CentOS 7
- Debian 7 (Wheezy)
- Debian 8 (Jessie)
- Fedora 21
- Fedora 22
- OpenSUSE 13
- Oracle Linux 7
- Ubuntu 12.04 (Precise)
- Ubuntu 14.04 (Trusty)
- Ubuntu 15.04 (Vivid)


.. contents::

States
======

``docker``
----------

Adds Official Docker repositories and installs docker-engine.


**Variables of Note**

- **version** - The version of the docker-engine you wish to install.
- **env_vars** - A dict of environment variables the docker-engine should be started with.
- **opts** - A dict of options to pass the docker daemon. All items should be passed as a list.
- **users** - A list of users that should be added to the docker group.

**Pillar Example:**

::

docker:
  lookup:
    engine:
      version: 1.10.1
      env_vars:
        DOCKER_HOST: /var/run/docker.sock
        TLS_VERIFY: TRUE
      opts: 
        dns: 
          - 8.8.8.8
          - 8.8.4.4
      users:
        - vagrant

``docker.compose``
------------------

Installs docker-compose and if specified, the bash-completion module as well.

**Pillar Example:**

::

docker:
  lookup:
    compose:
      version: 1.6.0
      completion: true


``docker.users``
----------------

Creates the docker group and adds any user specified in the docker engine pillar to be added to the group.
This group is granted rights to execute docker without having to ``sudo``.
