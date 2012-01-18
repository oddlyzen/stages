module Stages
  class Exhaust < Stage
    def process
      results = []
      while value = input
        results << value
      end
      output results
    end
  end
end
