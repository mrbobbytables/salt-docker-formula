{% from 'docker/map.jinja' import volume with context %}
{% from 'docker/map.jinja' import images with context %}
{% from 'docker/map.jinja' import containers with context %}

include:
  - docker.engine
{% if images|length != 0 %}
  - docker.images
{% endif %}
{% if containers|length != 0 %}
  - docker.containers
{% endif %}
{% if volume.driver|length != 0 %}
  - docker.volume
{% endif %}
