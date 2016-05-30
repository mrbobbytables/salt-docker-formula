{% from "docker/map.jinja" import engine with context %}

docker-engine-config:
  file.managed:
    - name: /etc/default/docker
    - source: salt://docker/engine/templates/sysvinit-opts.jinja
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
