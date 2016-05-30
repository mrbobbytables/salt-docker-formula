======
Docker
======
.. image:: https://travis-ci.org/mrbobbytables/salt-docker-formula.svg?branch=master

Formula for managing the install and configuration of both Docker-Engine and Docker-Compose.

Tested with the following platforms:

- CentOS 6
- CentOS 7
- Debian 7 (Wheezy)
- Debian 8 (Jessie)
- Fedora 22
- Fedora 23
- OpenSUSE 13
- Oracle Linux 7
- Ubuntu 12.04 (Precise)
- Ubuntu 14.04 (Trusty)


.. contents::

States
======


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


``docker.engine``
----------

Adds Official Docker repositories and installs docker-engine. If cs_engine is set to `true` it will install the commercially supported engine.


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
        cs_engine: true
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


``docker.engine.users``
----------------

Creates the docker group and adds any user specified in the docker engine pillar to be added to the group.
This group is granted rights to execute docker without having to ``sudo``.


``docker.volume``
----------------

Adds docker volumes based on supplied storage driver. Currently only ``local_persist`` is supported.


**Pillar Example:**

::

  docker:
   lookup:
    volume:
      driver:
        local_persist:
          version: 1.1.0
          volumes:
            test-persist:
              mountpoint: /tmp/test


``docker.images``
----------------

Downloads specified images.


**Pillar Example:**

::

  docker:
   lookup:
    images:
      - registry:2
      - ubuntu:14.04

``docker.containers``
----------------

Runs and configures containers. Options are passed to the dockerng module.


**Pillar Example:**

::

  docker:
   lookup:    
    containers:
      test:
        image: "ubuntu:14.04"
        binds:
          - /mnt/data/:/opt/data/:rw
        port_bindings:
          - 5000:5000
        network_mode: bridge
        restart_policy: always

