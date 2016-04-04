require 'serverspec'
require 'yaml'

set :backend, :exec

pillar_data = YAML.load_file('/tmp/kitchen/srv/pillar/docker.sls')

describe 'SLS: docker.compose.install' do

  describe 'STATE: get-compose' do
    describe file('/usr/local/bin/docker-compose') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end

    if pillar_data['docker']['lookup']['compose']['version']
      describe command('/usr/local/bin/docker-compose --version') do
        its(:stdout) { should match pillar_data['docker']['lookup']['compose']['version'] }
      end
    end
  end

  if pillar_data['docker']['lookup']['compose']['completion']
    describe 'STATE: get-compose-completion' do
      describe file('/etc/bash_completion.d/docker-compose') do
        it { should be_file }
      end
    end
  end
end

