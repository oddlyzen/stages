module Stages
  class Stage
    attr_accessor :source
    
    def initialize(&block)
      @block = block
      initialize_loop
    end
    
    def initialize_loop
       @fiber_delegate = Fiber.new do
        process
        die
      end
    end
    
    def run
      @fiber_delegate.resume    
    end
    
    def continue
      @fiber_delegate = Fiber.new do
        process
        die
      end
      @source.continue
    end
    
    def die
      loop do
        output nil
      end
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
 
