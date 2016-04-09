{% set provider = salt['test.provider']('service')|lower %}


local-persist-create-service-def:
  file.managed:
    - mode: 644
{% if provider == 'upstart' %}
    - name: /etc/init/docker-volume-local-persist.conf
    - source: salt://docker/volume/local_persist/files/local-persist.upstart
{% elif provider == 'systemd' %}
    - name: /etc/systemd/system/docker-volume-local-persist.service
    - source: salt://docker/volume/local_persist/files/local-persist.service
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: local-persist-create-service-def
{% endif %}


local-persist-start-service:
  service.running:
    - name: docker-volume-local-persist
    - enable: true
    - watch:
      - file: local-persist-create-service-def
