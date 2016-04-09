require 'serverspec'
require 'yaml'

set :backend, :exec

pillar_data = YAML.load_file('/tmp/kitchen/srv/pillar/docker.sls')
local_persist_version = pillar_data['docker']['lookup']['volume']['driver']['local_persist']['version']

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
