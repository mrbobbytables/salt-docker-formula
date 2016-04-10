require 'serverspec'
require 'yaml'

set :backend, :exec

pillar_data = YAML.load_file('/tmp/kitchen/srv/pillar/docker.sls')
local_persist_version = pillar_data['docker']['lookup']['volume']['driver']['local_persist']['version']
local_persist_volumes = pillar_data['docker']['lookup']['volume']['driver']['local_persist']['volumes']

describe 'SLS: docker.volume.local_persist.install' do

  describe 'STATE: get-docker-volume-driver-local-persist' do
    describe file('/usr/local/bin/docker-volume-local-persist-' + local_persist_version) do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
  end

 describe 'STATE: create-docker-volume-persist-symlink' do
   describe file('/usr/local/bin/docker-volume-local-persist') do
     it { should exist }
     it { should be_symlink }
     it { should be_executable }
   end
 end
end

describe 'SLS: docker.volume.local_persist.service' do
  describe service('docker-volume-local-persist') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'SLS: docker.volume.local_persist.config' do
  local_persist_volumes.each do | key, value |
    describe command('docker volume ls') do
      its(:stdout) { should contain key }
    end
    describe command("docker volume inspect #{key}") do
      its(:stdout) { should contain value['mountpoint'] }
    end
  end
end
