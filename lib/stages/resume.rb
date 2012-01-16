module Stages
  class Resume < Stage    
    def input
      result = []
      while v = source.run
        result << v
      end
      continued = @source.reset
      if continued.nil?
        nil
      else
        { continued => result}
      end
    end
  end
end
