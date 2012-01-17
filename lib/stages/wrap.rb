module Stages
  class Wrap < Stage    
    def initialize(pipeline, *args)
      @pipeline = pipeline
      @output_style = :hash
      unless args.empty?
        if args.include? :array
          @output_style = :array        
        elsif args.include? :each
          @output_style = :each
        end
        @aggregated = true if args.include? :aggregated
      end
      super()
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
