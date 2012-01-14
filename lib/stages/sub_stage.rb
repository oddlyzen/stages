module Stages
  class SubStage < Stage    
    def initialize(pipeline)
      @pipeline = pipeline
      super()
    end
    
    def handle_value(value)
      results = []
      subpipe = (EachElement.new([value]) | @pipeline)
      while v = subpipe.run
        results << v
      end
      @pipeline.drop_leftmost!
      @pipeline.continue
      results = results.first if results.length == 1
      output ({ value => results })
    end
  end  
end
