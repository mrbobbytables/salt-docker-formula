{% from 'docker/map.jinja' import engine with context %}

docker-engine-config:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/docker-opts.conf
    - source: salt://docker/engine/templates/systemd-opts.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: docker-engine-config

docker-engine-service:
  service.running:
    - name: docker
    - enable: true
    - restart: true
    - require:
      - pkg: {{ engine.pkg.name }}
    - watch:
      - file: docker-engine-config


