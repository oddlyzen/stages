module Stages
  class MultiplesOf < Stage
    def initialize(factor)
      @factor = factor
      super()
    end
    
    def handle_value(value)
      output(value) if value % @factor == 0
    end 
  end 
end
