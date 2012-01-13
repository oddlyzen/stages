require 'helper'
Dir["#{File.dirname(__FILE__)}/../dataprocessing/pipeline/*.rb"].each {  |file| require file.gsub(".rb", "")}
Dir["#{File.dirname(__FILE__)}/../dataprocessing/pipeline/stages/*.rb"].each { |file| require file.gsub(".rb", "")}
include Pipeline

class TestPipeline < MiniTest::Unit::TestCase
  
  test 'simple basic pipeline' do
    evens = Evens.new
    mx3 = MultiplesOf.new(3)
    mx7 = MultiplesOf.new(7) 
    mx3.source = evens 
    mx7.source = mx3
    
    result = (0..2).map{ |x| mx7.run }
    assert_equal([0, 42, 84], result)
  end
  
  test 'pipeline pipe syntax works' do
    pipeline = Evens.new | MultiplesOf.new(3) | MultiplesOf.new(7)
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([0, 42, 84], result)
  end
  
  test 'exceptions do what you expect' do
    begin
      pipeline = Evens.new | Map.new{ |val| throw Exception.new "exception!" } | Select.new{ |v| v > 2}
      pipeline.run
      assert false
    rescue Exception => e
    end
  end  
  
  test 'splitter splits' do
    
  end
  
  def sing
    { :do => 'doe a deer a female deer',
      :re => 'ray a drop of golden sun',
      :mi => 'me a name I call myself',
      :fa => 'far a long long way to run',
      :so => 'A needle pulling thread',
      :la => 'a note to follow so',
      :ti => 'a drink with jam and bread'}
  end
end
