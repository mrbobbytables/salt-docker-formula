{% from "docker/map.jinja" import engine with context %}

docker-engine-install:
  pkg.installed:
    - name: {{ engine.pkg.name }}
    {% if 'version' in engine and engine.version is not none %}
    - version: "{{ engine.version }}*"
    {% endif %}
