require 'datacenter'
require 'class_config'

require_relative 'simple_profiler/version'
require_relative 'simple_profiler/event'
require_relative 'simple_profiler/reporters/logger'
require_relative 'simple_profiler/reporters/summary'

Datacenter.logger.level = Logger::ERROR

module SimpleProfiler

  extend ClassConfig
  attr_config :reporters, [SimpleProfiler::Reporters::Logger.new(Logger.new(STDOUT))]
  attr_config :enabled_log_memory, true
  attr_config :track_method_args, true

  class << self

    def profile_instance_methods(klass, *methods)
      methods.each do |method|
        new_method = "__#{method}_profiled__"
        klass.send :alias_method, new_method, method
        klass.send(:define_method, method) do |*args, &block|
          SimpleProfiler.track klass, :instance, method, args do
            send new_method, *args, &block
          end
        end
      end
    end

    def profile_class_methods(klass, *methods)
      methods.each do |method|
        new_method = "__#{method}_profiled__"
        klass.singleton_class.send :alias_method, new_method, method
        klass.send(:define_singleton_method, method) do |*args, &block|
          SimpleProfiler.track klass, :class, method, args do
            send new_method, *args, &block
          end
        end
      end
    end

    def track(klass, target, method, args)
      started_at = Time.now
      memory = process_memory
      
      result = yield
      
      tracked_args = track_method_args ? args : []
      notify Event.new(klass, target, method, tracked_args, started_at, Time.now, memory, process_memory)
      result
    end

    private

    def notify(event)
      reporters.each do |report|
        report.notify event
      end
    end

    def process
      @process ||= Datacenter::Process.new Process.pid
    end

    def process_memory
      enabled_log_memory ? process.memory : 0
    end

  end
end
