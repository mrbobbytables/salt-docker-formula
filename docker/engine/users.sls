{% from "docker/map.jinja" import engine with context %}

create-docker-group:
  group.present:
    - name: docker
    - system: true
{% if 'users' in engine and engine.users|length > 0 %}
    - members:
{% for user in engine.users %}
      - {{ user }}
{% endfor %}
{% endif %}
