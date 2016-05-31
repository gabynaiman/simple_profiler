module SimpleProfiler
  class Event < Struct.new(:klass, :target, :method, :args, :started_at, :finalized_at, :memory_at_beginning, :memory_at_end)
    
    def total_time
      finalized_at - started_at
    end

    def used_memory
      memory_at_end - memory_at_beginning
    end

    def to_s
      separator = target == :class ? '.' : '#'
      "#{klass}#{separator}#{method} -> #{total_time.round(4)} sec. - #{used_memory}MB - (Total Memory: #{memory_at_end}MB)"
    end
  end
end