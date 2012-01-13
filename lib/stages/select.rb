module Pipeline
  class Select < Stage 
    def handle_value(value)
      output(value) if @block.call(value)
    end
  end
end
