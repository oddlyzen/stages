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
  get_lyric = HashLookup.new sing
  each_character = EachInput.new{ |x| x.chars }
  whitespace = Select.new{ |x| x != ' '}
  sub_pipeline = get_lyric | each_character | whitespace 
  process_elements = SubStage.new(sub_pipeline)
  
  generator = EachElement.new sing.keys
  subtotals = Map.new { |x| x.values.first }
  iterator = EachInput.new
  count = Count.new
  
  generator | process_elements | subtotals | iterator | count
end

puts setup_pipeline.run.inspect



