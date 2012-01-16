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

class Lyrics < Stage
  attr_accessor :lyrics
  def handle_value(value)
    output @lyrics[value]
  end
end

class Generator < Stage
  def initialize(things)
    @things = things
    super()
  end
  
  def process
    @things.each do |t|
      output t
    end
  end
end

def setup_pipeline
  get_lyric = Lyrics.new
  get_lyric.lyrics = @lyrics
  
  each_character = Each.new{ |x| x.chars }
  trim_whitespace = Select.new{ |x| x != ' '}
  letters_in_each_line = Wrap.new(get_lyric | each_character | trim_whitespace)
  each_letter = Each.new
  each_note = Generator.new(@lyrics.keys)
  count_everything = Count.new
  
  each_note | letters_in_each_line | each_letter | count_everything
end

puts setup_pipeline.run.inspect



