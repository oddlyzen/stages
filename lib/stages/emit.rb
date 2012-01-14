module Stages
  class Emit < Stage
    def initialize(thing)
      @thing = thing
      super()
    end
        
    def process 
      output @thing
    end
  end
end
