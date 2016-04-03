{% from "docker/map.jinja" import engine with context %}


docker-engine-install:
  pkg.installed:
    - name: {{ engine.pkg.name }}
    {% if 'version' in engine and engine.version is not none %}
    - version: "{{ engine.version }}*"
    {% endif %}

{% if engine.opts_type == 'systemd' %}
include: 
  - docker.engine.systemd
{% endif %}
    
