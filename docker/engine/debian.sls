{% from "docker/map.jinja" import engine with context %}

docker-engine-remove-old-versions:
  pkgrepo.absent:
    - name: deb https://get.docker.com/{{ salt['grains.get']('os')|lower }} docker main
  pkg.purged:
    - pkgs:
      - "lxc-docker*"
      - "docker.io*"

docker-engine-repo-prereqs:
  pkg.installed:
    - pkgs:
      - apt-transport-https
{# cannot use engine.opts|selectattr("storage-driver", "equalto", "aufs") in this instance to maintain #}
{# compatibility with ubuntu precise #}
{% if 'storage-driver' in engine.opts and engine.opts['storage-driver'][0] == 'aufs' %}
      - linux-image-extra-{{salt['grains.get']('kernelrelease')}}
{% endif %}



docker-engine-repo:
  pkgrepo.managed:
    - name: {{ engine.pkg.source }}
    - humanname: Docker Official {{ salt['grains.get']('os') }} Repo
    - key_url: {{ engine.pkg.key_url }}
    - file: /etc/apt/sources.list.d/docker.list
    - clean_file: true
    - refresh_db: true
    - require:
      - pkg: docker-engine-repo-prereqs


docker-engine-install:
  pkg.installed:
    - name: {{ engine.pkg.name }}
    {% if 'version' in engine and engine.version is not none %}
    - version: "{{ engine.version }}*"
    {% endif %}
    - require:
      - pkgrepo: docker-engine-repo

{% if engine.opts_type == 'systemd' %}
include: 
  - docker.engine.systemd
{% elif engine.opts_type == 'default' %}

docker-engine-config:
  file.managed:
    - name: /etc/default/docker
    - source: salt://docker/engine/templates/default-opts.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

docker-engine-service:
  service.running:
    - name: docker
    - enable: true
    - restart: true
    - require:
      - pkg: docker-engine
    - watch:
      - file: /etc/default/docker
{% endif %}

