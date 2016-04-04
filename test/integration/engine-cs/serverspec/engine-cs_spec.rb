require 'serverspec'
require 'yaml'

set :backend, :exec
 
if os[:family] == 'opensuse'
  pkg_name = 'docker'
else
  pkg_name = 'docker-engine'
end

engine_vars = YAML.load_file('/tmp/kitchen/srv/pillar/docker.sls')

describe 'SLS: docker.engine.*' do

  describe 'STATE: docker-engine-install' do
    describe package(pkg_name) do
      it { should be_installed }
    end

    if engine_vars['docker']['lookup']['engine']['version']
      describe command('docker --version') do
        its(:stdout) { should match engine_vars['docker']['lookup']['engine']['version'] }
        its(:stdout) { should match /-cs\d+/ }
      end
    end
  end


  describe 'STATE: docker-engine-config' do
    if engine_vars['docker']['lookup']['engine']['opts']
      describe command('ps -aux | grep docker') do
        engine_vars['docker']['lookup']['engine']['opts'].each do |k,v|
          its(:stdout) { should contain k,v }
        end
      end
    end

    if engine_vars['docker']['lookup']['engine']['env_vars']
      describe command('cat /proc/$(pgrep docker)/environ') do
        engine_vars['docker']['lookup']['engine']['env_vars'].each do |k,v|
          its(:stdout) { should contain k,v }
        end
      end
    end
  end


  describe 'STATE: docker-engine-service' do
    describe service('docker') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe 'LITMUS: pull and execute hello-world container' do
    describe command('docker run hello-world') do
      its(:stdout) { should match "This message shows that your installation appears to be working correctly."}
    end
  end
end


if engine_vars['docker']['lookup']['engine']['users']
  describe 'SLS: docker.engine.users' do
    describe group ('docker') do
      it { should exist }
    end  

    engine_vars['docker']['lookup']['engine']['users'].each do |user|
      describe user(user) do
        it { should belong_to_group 'docker' }
      end
    end
  end
end

