module Pipeline
  class Stage
    attr_accessor :source
    
    def initialize(&block)
      @block = block
      @fiber_delegate = Fiber.new do
        process
      end
    end
    
    def run
      @fiber_delegate.resume
    end
    
    def process
      while value = input
        handle_value value
      end
    end
    
    def handle_value(value)
      output value
    end
    
    def input
      source.run
    end
    
    def output(value)
      Fiber.yield value
    end
      
    def |(other=nil)
      other.source = self
      other
    end
  end  
end 
 
