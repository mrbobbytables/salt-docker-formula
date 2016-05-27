{% from 'docker/map.jinja' import engine with context %}
{% set os_family = salt['grains.get']('os_family') %}

include:
  - docker.engine.install
  - docker.engine.users
