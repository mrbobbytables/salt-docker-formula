{% from 'docker/map.jinja' import volume with context %}
{% set local_persist = volume.driver.local_persist %}
{% set local_persist_url = 'https://github.com/CWSpear/local-persist/releases/download/v' ~ local_persist.version ~ '/local-persist-linux-amd64' %}
 
local-persist-prereq-install-curl:
  pkg.installed:
    - name: curl
  
get-docker-volume-driver-local-persist:
  cmd.run:
    - name: | 
        curl -L {{ local_persist_url }} > /usr/local/bin/docker-volume-local-persist-{{ local_persist.version }}
        chmod +x /usr/local/bin/docker-volume-local-persist-{{ local_persist.version }}
    - unless: docker-volume-local-persist --version | grep -q {{ local_persist.version }}
    - require:
      - pkg: local-persist-prereq-install-curl

create-docker-volume-local-persist-symlink:
  file.symlink:
    - name: /usr/local/bin/docker-volume-local-persist
    - target: /usr/local/bin/docker-volume-local-persist-{{ local_persist.version }}
    - onlyif:
      - test -f /usr/local/bin/docker-volume-local-persist-{{ local_persist.version }}
