{% from 'docker/map.jinja' import containers with context %}

include:
  - docker.containers.prereqs

docker_chain_nat:
  iptables.chain_present:
    - name: 'DOCKER'
    - table: 'nat'

docker_chain_filter:
  iptables.chain_present:
    - name: 'DOCKER'
    - table: 'filter'

{% for name, opts in containers.items() %}
container_{{ name }}:
  dockerng.running:
    - name: {{ name }}
    {% for opt, vals in opts.items() %}
    - {{ opt }}: {{ vals }}
    {% endfor %}
    - require:
      - dockerng: {{ opts.image }}
      - pip: dockerng_requirements
      - service: docker-engine-service
{% endfor %}
