require 'helper'
Dir["#{File.dirname(__FILE__)}/../dataprocessing/pipeline/*.rb"].each {  |file| require file.gsub(".rb", "")}
Dir["#{File.dirname(__FILE__)}/../dataprocessing/pipeline/stages/*.rb"].each { |file| require file.gsub(".rb", "")}
include Pipeline

class TestStages < MiniTest::Unit::TestCase
  
  test 'evens' do
    evens = Evens.new
    result = (0..2).map{ evens.run }
    assert_equal([0, 2, 4], result)
  end
    
  test 'select' do
    pipeline = Evens.new | Select.new{ |val| val > 6}
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([8, 10, 12], result)
  end
  
  test 'map' do
    pipeline = Evens.new | Map.new{ |val| val * 3}
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([0, 6, 12], result)
  end
  
  test 'multiples_of' do
    pipeline = Evens.new | MultiplesOf.new(3)
    result = (0..3).map{ |x| pipeline.run }
    assert_equal([0, 6, 12, 18], result)
  end
  
  test 'each_element' do
    pipeline = EachElement.new([1, 2, 3])
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([1, 2, 3], result)
  end
  
  test 'hash_lookup' do
    pipeline = EachElement.new([:do, :re, :mi]) | HashLookup.new(sing)
    result = (0..2).map{ |x| pipeline.run }
    assert_equal(['doe a deer a female deer', 'ray a drop of golden sun', 'me a name I call myself'], result)
  end 
  
  test 'stop' do
    pipeline = EachElement.new([1, 2, nil, 3])
    while v = pipeline.run
      puts v
    end
    
    
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
