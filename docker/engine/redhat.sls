{% from "docker/map.jinja" import engine with context %}

docker-engine-remove-old-versions:
  pkg.purged:
    - name: docker-io

docker-engine-repo:
  pkgrepo.managed:
    - name: docker
    - baseurl: {{ engine.pkg.source }}
    - gpgkey: {{ engine.pkg.key_url }}
    - humanname: Docker Official {{ salt['grains.get']('os') }} Repo
    - gpgcheck: 1

docker-engine-install:
  pkg.installed:
    - name: {{ engine.pkg.name }}
    {% if 'version' in engine and engine.version is not none %}
    - version: "{{ engine.version }}*"
    {% endif %}
    - require:
      - pkgrepo: docker-engine-repo
