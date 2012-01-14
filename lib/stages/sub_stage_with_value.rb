module Stages
  class SubStageWithValue < Stage    
    def initialize(pipeline)
      @pipeline = pipeline
      @cache = []
      super()
    end
    
    def process
      while value = input
        subpipe = Emit.new(value) | @pipeline
        while v = subpipe.run
          output ({value => v})
        end
        @pipeline.drop_leftmost!
        @pipeline.continue
      end
    end
  end  
end
