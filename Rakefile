require 'rake'
require 'kitchen/rake_tasks'

task :default => 'test:vagrant'

namespace :test do

  Kitchen.logger = Kitchen.default_file_logger

  desc 'Run test-kitchen (locally) via vagrant'
  task :vagrant, [:threads] do |t, args|
    args.with_defaults(threads: 1)
    @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.yml')
    config = Kitchen::Config.new(loader: @loader)
    queue = Queue.new
    config.instances.each { |i| queue << i }
    workers = (0...args[:threads].to_i).map do
      Thread.new do
        begin
          while instance = queue.pop(true)
            instance.send('test')
          end
        rescue ThreadError
        end
      end
    end
    workers.map(&:join)
  end
  
  %w(verify destroy).each do |c_task|
    desc "Run test-kitchen with a cloud provider"
    namespace :cloud do
      task c_task do
        @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
        config = Kitchen::Config.new(loader: @loader)
        concurrency = config.instances.size
        queue = Queue.new
        config.instances.each { |i| queue << i }
        workers = (0...concurrency).map do
          Thread.new do
            begin
              while instance = queue.pop(true)
                instance.send(c_task)
              end
            rescue ThreadError
            end
          end
        end
        workers.map(&:join)
      end
    end
  end
  task cloud: [ 'cloud:verify', 'cloud:destroy']
end
