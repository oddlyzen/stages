module Stages
  class ResumeCount < Stage    
    def input
      result = Hash.new{ |h, k| h[k] = 0 }
      while v = source.run
        result[v] += 1
      end
      continued = @source.continue
      if continued.nil?
        nil
      else
        { continued => result}
      end
    end
  end
end
