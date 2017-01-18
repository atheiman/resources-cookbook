require 'bundler/setup'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run test-kitchen commands'
namespace :kitchen do
  require 'kitchen'
  Kitchen.logger = Kitchen.default_file_logger

  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    instances = instances.get_all(Regexp.new(regexp)) unless regexp.nil? || regexp == 'all'
    raise Kitchen::UserError, "regexp '#{regexp}' matched 0 instances" if instances.empty?
    instances
  end

  # Runs a test kitchen command against some instances.
  #
  # @param command [String] kitchen command to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param concurrency [#to_i] number of instances to run the command against concurrently.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(command, regexp, concurrency, loader_config: {})
    puts "command: #{command}"
    puts "regexp: #{regexp}"
    puts "concurrency: #{concurrency}"
    puts "loader_config: #{loader_config}"

    config = { loader: Kitchen::Loader::YAML.new(loader_config) }

    call_threaded(
      kitchen_instances(regexp, config),
      command,
      concurrency
    )
  end

  # Calls a method on a list of objects in concurrent threads.
  #
  # @param objects [Array] list of objects.
  # @param method_name [#to_s] method to call on the objects.
  # @param concurrency [Integer] number of objects to call the method on concurrently.
  # @return void
  def call_threaded(objects, method_name, concurrency)
    threads = []
    raise 'concurrency must be > 0' if concurrency < 1
    objects.each do |obj|
      sleep 3 until threads.map(&:alive?).count(true) < concurrency
      threads << Thread.new { obj.method(method_name).call }
    end
    threads.map(&:join)
  end

  def local_config_to_loader_config(local_config)
    local_config.empty? ? {} : { local_config: local_config }
  end

  # dynamically create tasks for each kitchen action
  %i(create converge verify destroy test).each do |command|
    task command, :regexp, :concurrency, :local_config do |_t, args|
      args.with_defaults(
        regexp: 'all',
        concurrency: 1,
        local_config: ''
      )
      loader_config = local_config_to_loader_config(args.local_config)
      run_kitchen(
        command,
        args.regexp,
        args.concurrency.to_i,
        loader_config: loader_config
      )
    end
  end
end
