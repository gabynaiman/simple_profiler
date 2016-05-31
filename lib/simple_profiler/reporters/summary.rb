module SimpleProfiler
  module Reporters
    class Summary

      attr_reader :events
      
      def initialize
        @events = []
      end

      def notify(event)
        @events << event
      end

      def ranking(options={})
        order = options.fetch(:sort_by, :total_time)

        events_by_method = events.group_by {|e| {klass: e.klass.to_s, method: e.method, target: e.target}}
        ranking = events_by_method.map do |key, values|
          key.merge statistics_for(values)
        end
        
        ranking.sort_by {|e| e[order]}.reverse
      end

      private

      def statistics_for(events)
        count = 0
        total_time = 0
        total_memory = 0

        events.each do |e|
          count += 1
          total_time += e.total_time
          total_memory += e.used_memory
        end

        {
          hits: count, 
          total_time: total_time, 
          avg_time: count == 0 ? 0 : total_time / count, 
          total_memory: total_memory, 
          avg_memory: count == 0 ? 0 : total_memory / count
        }
      end

    end
  end
end