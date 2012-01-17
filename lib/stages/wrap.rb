module Stages
  class Wrap < Stage    
    def initialize(pipeline)
      @pipeline = pipeline
      @output_style = :hash
      @aggregated = false
      super()
    end
    
    def array
      @output_style = :array
      self
    end
    
    def each
      @output_style = :each
      self
    end
    
    def aggregated
      @aggregated = true
      self
    end
    
    def process
      while value = input
        subpipe = Emit.new(value) | @pipeline
        results = []
        while v = subpipe.run
          @output_style == :each ? output(v) : results << v
        end      
        results = results.first if @aggregated
        output results if @output_style == :array
        output({ value => results}) if @output_style == :hash
        @pipeline.drop_leftmost!
        @pipeline.reset!
      end
    end
  end  
end
