require "#{File.dirname(__FILE__)}/../lib/stages"

include Stages

#count the occurance of each letter in these song lyrics
def sing
  { :do => 'doe a deer a female deer',
    :re => 'ray a drop of golden sun',
    :mi => 'me a name I call myself',
    :fa => 'far a long long way to run',
    :so => 'a needle pulling thread',
    :la => 'a note to follow so',
    :ti => 'a drink with jam and bread'}
end

def setup_pipeline
  generator = Each.new sing.keys
  loop = Restrict.new
  get_lyric = HashLookup.new sing
  each_character = Each.new{ |x| x.chars }
  whitespace = Select.new{ |x| x != ' '}
  pool = ResumeCount.new
  subtotals = Map.new { |x| x.values.first }
  iterator = Each.new
  aggregator = SuperAggregator.new
  
  generator | loop | get_lyric | each_character | whitespace | pool | subtotals | iterator  |  aggregator
end

class SuperAggregator < Stage
  def initialize
    @accumulator = Hash.new{ |h,k| h[k] = 0}
    super()
  end
  
  def handle_value(value)
    @accumulator[value[0]] += value[1]
    while v = input
      @accumulator[v[0]] += v[1]
    end
    output @accumulator
  end
end

puts setup_pipeline.run.inspect



