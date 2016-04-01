{% from "docker/map.jinja" import engine with context %}

docker-engine-install:
  pkg.installed:
    - name: {{ docker.pkg.name }}
    {% if 'version' in docker and docker.version is not none %}
    - version: "{{ engine.version }}*"
    {% endif %}

{% if engine.opts_type == 'systemd' %}
include: 
  - docker.engine.systemd
{% endif %}
    
