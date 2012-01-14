module Stages
  class SubStage < Stage    
    def initialize(pipeline)
      @pipeline = pipeline
      @cache = []
      @with_hash = false
      super()
    end
    
    def with_hash
      @with_hash = true
      self
    end
    
    def process
      while value = input
        subpipe = Emit.new(value) | @pipeline
        while v = subpipe.run
          v = { value => v} if @with_hash
          output v
        end
        @pipeline.drop_leftmost!
        @pipeline.continue
      end
    end
  end  
end
