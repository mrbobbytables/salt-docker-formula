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
	
	desc "Run test-kitchen with a cloud provider"
  task :cloud, [:args] do |t, args|
		args.with_defaults(threads: 10)
		@loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
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
end
