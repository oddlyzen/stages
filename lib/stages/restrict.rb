module Stages
  class Restrict < Stage
    def initialize(name = :default)
      @open = true
      @name = name
      super()
    end
    
    def continue(name = :default)
      if name == @name
        @open = true
      else
        super.continue(name)
      end
    end
    
    def process
      while value = input
        if @open
          @open = false
          handle_value value
        else
          while !@open
            handle_value nil
          end
          @open = false
          handle_value value
        end
      end
    end
  end
end 
