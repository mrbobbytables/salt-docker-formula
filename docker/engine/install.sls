{% from 'docker/map.jinja' import engine with context %}
{% set os_family = salt['grains.get']('os_family') %}

include:
{% if os_family  == 'Debian' %}
  - docker.engine.debian
{% elif os_family == 'RedHat' %}
  - docker.engine.redhat
{% elif os_family == 'Suse' %}
  - docker.engine.suse
{% endif %}
{% if engine.opts_type == 'systemd' %}
  - docker.engine.systemd
{% elif engine.opts_type == 'sysvinit' %}
  - docker.engine.sysvinit
{% elif engine.opts_type == 'sysconfig' %}
  - docker.engine.sysconfig
{% endif %}
