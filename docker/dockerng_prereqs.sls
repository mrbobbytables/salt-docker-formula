
dockerng_req_packages:
  pkg.installed:
    - pkgs:
      - python-pip

pip_docker_six:
  pip.installed:
    - name: six > 1.7
    - reload_modules: True
    - require:
      - pkg: dockerng_req_packages

pip_docker_websocket:
  pip.installed:
    - name: websocket-client
    - reload_modules: True
    - require:
      - pkg: dockerng_req_packages

dockerng_requirements:
  pip.installed:
    - name: docker-py > 1.4.0
    - reload_modules: True
    - require:
      - pkg: dockerng_req_packages
      - pip: pip_docker_six
      - pip: pip_docker_websocket
