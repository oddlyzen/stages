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
  each_character = Each.new{ |x| x.chars }
  trim_whitespace = Select.new{ |x| x != ' '}
  letters_in_each_line = SubStage.new(get_lyric | each_character | trim_whitespace)
  
  each_note = Each.new sing.keys
  count_everything = Count.new
  
  each_note | letters_in_each_line | count_everything
end

puts setup_pipeline.run.inspect



