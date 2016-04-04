require 'rake'
require 'kitchen/rake_tasks'

task :default => 'test:vagrant'

  def task_runner(config, suite_name, action, concurrency)
    task_queue = Queue.new
    instances = config.instances.select { | obj | obj.suite.name  =~ /^#{suite_name}$/ }
    instances.each { |i| task_queue << i }
    workers = (0...concurrency).map do
      Thread.new do
        begin
          while instance = task_queue.pop(true)
            instance.send(action)
          end
        rescue ThreadError
        end
      end
    end
    workers.map(&:join)
  end




namespace :test do

  Kitchen.logger = Kitchen.default_file_logger

  desc 'Execute the full Vagrant test suites for engine, csengine, and compose'
  task :vagrant do
    @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.yml')
    config = Kitchen::Config.new(loader: @loader)
    concurrency = (ENV["concurrency"] || "1").to_i
    task_runner(config, '.*', 'test', concurrency)
  end


  namespace :vagrant do

    @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.yml')
    config = Kitchen::Config.new(loader: @loader)
    concurrency = (ENV["concurrency"] || "1").to_i

    desc 'Execute the Vagrant test suite for the Open Source Docker Engine.'
    task :engine do
      task_runner(config, 'engine', 'test', concurrency)
    end

    desc 'Execute the Vagrant test suite for the Commercially Supported Docker Engine.'
    task :csengine do
      task_runner(config, 'csengine', 'test', concurrency)
    end

    desc 'Execute the Vagrant test suite for Docker Compose'
    task :compose do
      task_runner(config, 'compose', 'test', concurrency)
    end

    desc 'Destroy all Vagrant instances.'
    task :destroy do
      task_runner(config, '.*', 'destroy', concurrency)
    end
  end


 
  aws_env_vars = ['AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY', 'AWS_SSH_KEY_ID', 'AWS_SGROUP_ID']
  missing_aws_vars = []

  aws_env_vars.each do | aws_var |
    if not ENV.has_key? aws_var 
      missing_aws_vars.push(aws_var)
    end
  end

  if missing_aws_vars.empty?

    desc 'Execute the full cloud test suites for engine, csengine, and compose.'
    task :cloud do
      @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
      config = Kitchen::Config.new(loader: @loader)
      concurrency = (ENV["concurrency"] || "10").to_i
      task_runner(config, '.*', 'test', concurrency)
    end

    namespace :cloud do

      @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
      config = Kitchen::Config.new(loader: @loader)
      concurrency = (ENV["concurrency"] || "10").to_i

      desc 'Execute the Cloud test suite for the Open Source Docker Engine.'
      task :engine do
        task_runner(config, 'engine', 'test', concurrency)
      end

      desc 'Execute the Cloud test suite for the Commercially Supported Docker Engine.'
      task :csengine do
        task_runner(config, 'csengine', 'test', concurrency)
      end

      desc 'Execute the Cloud test suite for Docker Compose'
      task :compose do
        task_runner(config, 'compose', 'test', concurrency)
      end

      desc 'Destroy all Cloud instances.'
      task :destroy do
        task_runner(config, '.*', 'destroy', concurrency)
      end
    end
  end
end
