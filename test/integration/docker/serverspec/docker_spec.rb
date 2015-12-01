require 'serverspec'
require 'yaml'

set :backend, :exec
 
if os[:family] == 'opensuse'
  pkg_name = 'docker'
else
  pkg_name = 'docker-engine'
end

describe package(pkg_name) do
  it { should be_installed }
end

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe command('docker run hello-world') do
  its(:stdout) { should match "This message shows that your installation appears to be working correctly."}
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
        docker_vars['docker-pkg']['lookup']['opts'].each do |option|
          its(:stdout) { should contain option }
        end
      end
    end

	if ! docker_vars['docker-pkg']['lookup']['env_vars'].nil?
      describe command('cat /proc/$(pgrep docker)/environ') do
        docker_vars['docker-pkg']['lookup']['env_vars'].each do |e_var|
          its(:stdout) { should match e_var }
        end
      end
    end

	if ! docker_vars['compose']['lookup']['version'].nil?
	  describe command('/usr/local/bin/docker-compose --version') do
		its(:stdout) { should match docker_vars['compose']['lookup']['version'] }
	  end
	end

	if ! docker_vars['compose']['lookup']['completion'].nil?
	  describe file('/etc/bash_completion.d/docker-compose') do
        it { should be_file }
	  end
	end
  end
end
