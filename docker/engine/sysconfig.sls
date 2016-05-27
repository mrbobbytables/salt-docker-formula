{% from "docker/map.jinja" import engine with context %}

docker-config:
  file.managed:
    - name: /etc/sysconfig/docker
    - source: salt://docker/engine/templates/sysconfig-opts.jinja
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
      - file: docker-config
