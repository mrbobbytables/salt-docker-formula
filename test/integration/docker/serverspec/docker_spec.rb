require 'serverspec'
require 'yaml'

set :backend, :exec

  describe package('docker-engine') do
    it { should be_installed }
  end

  describe service('docker') do
    it { should be_enabled }
    it {should be_running }
  end

	if File.exists? ('/tmp/kitchen/srv/pillar/docker.sls')

		docker_vars = YAML.load_file('/tmp/kitchen/srv/pillar/docker.sls')
    if ! docker_vars.nil?

      if ! docker_vars['docker-pkg']['lookup']['version'].nil?
        describe command('docker --version') do
          its(:stdout) { should match docker_vars['docker-pkg']['lookup']['version'] }
        end
      end

      if ! docker_vars['docker-pkg']['lookup']['opts'].nil?
        describe command('ps -aux | grep docker') do
          its(:stdout) { should match docker_vars['docker-pkg']['lookup']['opts'] }
        end
      end
    end
  end
