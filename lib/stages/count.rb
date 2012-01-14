module Stages
  class Count < Stage    
    def input
      result = Hash.new{ |h, k| h[k] = 0 }
      while v = source.run
        result[v] += 1
      end
      result.empty? ? nil : result
    end
  end
end
