{% from 'docker/map.jinja' import volume with context %}
{% set local_persist = volume.driver.local_persist %}

{% for key, value in local_persist.get('volumes').iteritems() %}

{% set test_vol_cmd = 'docker volume ls | grep -E -q "^local-persist\s+' ~ key ~ '$"' %}
{% set test_vol_mount = 'docker volume inspect ' ~ key ~ ' | grep -E -q \'"Mountpoint": "' ~ value.mountpoint ~ '"\'' %}
{% set create_vol_cmd = 'docker volume create --driver=local-persist --name=' ~ key %}


create-volume-dir-{{ value.mountpoint }}:
  file.directory:
    - name: {{ value.mountpoint }}
    - makedirs: true


{% if salt['cmd.retcode'](cmd=test_vol_cmd, python_shell=true)|int != 0 %}

create-docker-volume-{{ key }}:
  cmd.run:
    - name: {{ create_vol_cmd }} {%- for v_key, v_val in value.iteritems() %} --opt={{ v_key }}={{ v_val }} {%- endfor %}

{% elif salt['cmd.retcode'](cmd=test_vol_mount, python_shell=true)|int != 0 %}

delete-docker-volume-{{ key }}:
  cmd.run:
    - name: docker volume rm {{ key }}

create-docker-volume-{{ key }}:
  cmd.run:
    - name: {{ create_vol_cmd }} {%- for v_key, v_val in value.iteritems() %} --opt={{ v_key }}={{ v_val }} {%- endfor %}
    - require:
      - cmd: delete-docker-volume-{{ key }}

{% endif %}
{% endfor %}
