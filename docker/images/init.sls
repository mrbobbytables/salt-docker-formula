{% from 'docker/map.jinja' import images with context %}

include:
  - docker.images.prereqs

{% for image in images %}
{{ image }}:
  dockerng.image_present:
    - require:
      - service: docker-engine-service
      - pip: dockerng_requirements
{% endfor %}
