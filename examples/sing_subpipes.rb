require "#{File.dirname(__FILE__)}/../lib/stages"

include Stages

#count the occurance of each letter in these song lyrics
@lyrics = 
  { :do => 'doe a deer a female deer',
    :re => 'ray a drop of golden sun',
    :mi => 'me a name I call myself',
    :fa => 'far a long long way to run',
    :so => 'a needle pulling thread',
    :la => 'a note to follow so',
    :ti => 'a drink with jam and bread'}

def setup_pipeline
  get_lyric = Map.new{ |x| @lyrics[x]}
  
  
  each_character = Each.new{ |x| x.chars }
  trim_whitespace = Select.new{ |x| x != ' '}
  letters_in_each_line = SubStage.new(get_lyric | each_character | trim_whitespace)
  each_note = Each.new @lyrics.keys
  count_everything = Count.new
  each_letter = Each.new
  
  
  each_note | letters_in_each_line | each_letter | count_everything
end

puts setup_pipeline.run.inspect

puts "one line at a time"
lyrics = Each.new(@lyrics.keys)
letters_in_chunks = SubStage.new(Map.new{ |x| @lyrics[x]} | Each.new{ |x| x.chars}).with_hash
each_letter = Each.new{ |x| x.values.first }
count = Count.new

p2 = lyrics | letters_in_chunks | each_letter | count

puts p2.run.inspect

