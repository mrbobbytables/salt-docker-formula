{% from 'docker/map.jinja' import volume with context %}

include:
  - docker.volume.prereqs
{% if 'local' in volume.driver %}
  - docker.volume.local
{% elif 'local_persist' in volume.driver %}
  - docker.volume.local_persist
{% endif %}

