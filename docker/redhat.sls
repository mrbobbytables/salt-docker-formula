{% from "docker/map.jinja" import docker with context %}

remove-old-versions:
  pkg.purged:
    - name: docker-io

docker-repo:
  pkgrepo.managed:
    - name: docker.repo
    - baseurl: {{ docker.pkgrepo.baseurl }}
    - humanname: Docker Official {{ grains.os }} Repo
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: {{ docker.pkgrepo.gpgkey }}

docker-engine:
  pkg.installed:
    - name: docker-engine
    {% if 'version' in docker %}
    - version: "{{ docker.version }}*"
    {% endif %}
    - require:
      - pkgrepo: docker-repo

{% if docker.opts_type == 'systemd' %}
include:
  - .systemd
{% endif %}
