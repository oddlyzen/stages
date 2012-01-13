module Pipeline
  class Map < Stage    
    def handle_value(value)
      output @block.call(value)
    end
  end  
end
