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
        results = []
        while v = subpipe.run
          results << v
        end
        results = { value => results} if @with_hash
        output results
        @pipeline.drop_leftmost!
        @pipeline.continue
      end
    end
  end  
end
