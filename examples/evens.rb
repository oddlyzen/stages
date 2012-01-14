module Stages
  class Evens < Stage
    def process 
      value = 0
      loop do
        output(value)
        value += 2
      end
    end
  end
end
