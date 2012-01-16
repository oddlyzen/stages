module Stages
  class Wrap < Stage    
    def initialize(pipeline)
      @pipeline = pipeline
      @cache = []
      @output_style = :hash
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
    
    def process
      while value = input
        subpipe = Emit.new(value) | @pipeline
        results = []
        while v = subpipe.run
          @output_style == :each ? output(v) : results << v
        end        
        output results if @output_style == :array
        output({ value => results}) if @output_style == :hash
        @pipeline.drop_leftmost!
        @pipeline.continue
      end
    end
  end  
end
