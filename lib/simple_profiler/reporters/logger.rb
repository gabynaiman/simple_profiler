module SimpleProfiler
  module Reporters
    class Logger

      def initialize(logger, options={})
        @options = options
        @logger = logger
      end

      def notify(event)
        logger.debug event.to_s if login?(event)
      end

      private

      attr_reader :logger
      attr_reader :options    

      def login?(event)
        event.total_time >= options.fetch(:min_time, 0) || 
        event.used_memory >= options.fetch(:min_memory, 0)
      end

    end
  end
end