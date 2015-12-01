require 'rake'
require 'kitchen/rake_tasks'

task :default => 'test:vagrant'

namespace :test do

  Kitchen.logger = Kitchen.default_file_logger

  desc 'Run test-kitchen (locally) via vagrant'
  task :vagrant do
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end

  %w(verify destroy).each do |c_task|
    desc "Run test-kitchen task: #{c_task} with a cloud provider"
    namespace :cloud do
      task c_task do
        @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
        config = Kitchen::Config.new(loader: @loader)
        concurrency = config.instances.size
        queue = Queue.new
        config.instances.each { |i| queue << i }
        concurrency.times { queue << nil }
        threads = []
        concurrency.times do
          threads << Thread.new do
            while instance = queue.pop
              instance.send(c_task)
            end
          end
        end
        threads.map(&:join)
      end
    end
  end

  task cloud: ['cloud:verify', 'cloud:destroy']
end
