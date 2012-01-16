require 'set'

module Stages
  class Unique < Stage
    def initialize_loop
      @set = Set.new
      super()
    end

    def die
      @set = Set.new
      super()
    end
    
    def handle_value(value)
      output value if @set.add? value.hash
    end
  end
end
