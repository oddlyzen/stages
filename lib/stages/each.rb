module Stages
  class Each < Stage
    def initialize(things = nil, &block)
      @things = things unless things.nil?
      @block = block
      super()
    end
        
    def process 
      if @things
        process_things
      else
        process_inputs
      end
    end
    
    def process_inputs
      while v = input
        v = @block.call(v) if @block
        v.each do |v|
          output v
        end
      end
    end
    
    def process_things
      @things = @block.call(@things) if @block
      output nil if @things.nil?
      @things.each do |thing|
        output thing
      end
    end
  end
end
