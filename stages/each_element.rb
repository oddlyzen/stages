module Pipeline
  class EachElement < Stage
    def initialize(things)
      @things = things
      super()
    end
    
    def process 
      @things.each do |thing|
        output thing 
      end
    end
  end
end
