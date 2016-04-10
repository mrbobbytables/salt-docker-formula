{% from 'docker/map.jinja' import compose with context %}

get-compose-prereq-curl:
  pkg.installed:
    - name: curl

get-compose:
  cmd.run:
    - name: |
        curl -L https://github.com/docker/compose/releases/download/{{ compose.version }}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    - unless: docker-compose --version | grep -q {{ compose.version }}
    - require:
      - pkg: get-compose-prereq-curl

{% if compose.completion %}
get-compose-completion:
  cmd.wait:
    - name: |
        curl -L https://raw.githubusercontent.com/docker/compose/{{ compose.version }}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
    - watch:
      - cmd: get-compose
    - require:
      - pkg: get-compose-prereq-curl
{% endif %}
