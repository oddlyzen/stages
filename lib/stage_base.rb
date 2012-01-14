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
      initialize_loop
      @source.continue if @source
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
      
    def |(other)
      other.root_source.source = self
      other
    end
    
    def root_source
      source.nil? ? self : source.root_source
    end
    
    def drop_leftmost!
      if @source.end?
        @source = nil
      else
        @source.drop_leftmost!
      end
    end
    
    def end?
      @source.nil?
    end
    
    def length
      if source
        source.length + 1
      else
        1
      end
    end
  end  
end 
 
