module Stages
  class EachInput < Stage
    def handle_value(value)
      value.each do |i|
        output i
      end
    end
  end
end
