require 'helper'
include Stages

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
  
  test 'block stages work' do
    pipeline = Evens.new | Map.new{ |x| x * 3} | Select.new{ |x| x % 7 == 0}
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
       
  test 'nil kills it' do
    pipeline = EachElement.new([1, 2, nil, 3])
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([1, 2], result)    
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
