module Pipeline
  class HashLookup < Stage
    def initialize(things)
      @things = things
      super()
    end
    
    def handle_value(value)
      output @things[value]
    end
  end
end
