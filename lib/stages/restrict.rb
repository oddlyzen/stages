module Stages
  class Restrict < Stage
    alias :super_continue :continue
    
    def initialize
      @open = true
      super()
    end
    
    def continue
      @open = true
      r = @last_value
      @last_value = nil
      r
    end
    
    def process
      while value = input
        while !@open
          handle_value nil
        end
        @open = false
        @last_value = value
        handle_value value
      end
    end
  end
end
