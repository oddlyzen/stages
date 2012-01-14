require 'helper'
include Stages

class TestStages < MiniTest::Unit::TestCase
  
  test 'evens' do
    evens = Evens.new
    result = (0..2).map{ evens.run }
    assert_equal([0, 2, 4], result)
  end
    
  test 'select' do
    pipeline = Evens.new | Select.new{ |val| val > 6}
    result = (0..2).map{ pipeline.run }
    assert_equal([8, 10, 12], result)
  end
  
  test 'map' do
    pipeline = Evens.new | Map.new{ |val| val * 3}
    result = (0..2).map{ pipeline.run }
    assert_equal([0, 6, 12], result)
  end
  
  test 'multiples_of' do
    pipeline = Evens.new | MultiplesOf.new(3)
    result = (0..3).map{ pipeline.run }
    assert_equal([0, 6, 12, 18], result)
  end
  
  test 'each_element' do
    pipeline = EachElement.new([1, 2, 3])
    result = (0..2).map{ pipeline.run }
    assert_equal([1, 2, 3], result)
  end
  
  test 'hash_lookup' do
    pipeline = EachElement.new([:do, :re, :mi]) | HashLookup.new(sing)
    result = (0..2).map { pipeline.run }
    assert_equal(['doe a deer a female deer', 'ray a drop of golden sun', 'me a name I call myself'], result)
  end   
  
  test 'restrict' do
    pipeline = Evens.new | Restrict.new | Map.new{ |x| x * 2}
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([0], result)
    pipeline.continue
    while v = pipeline.run
      result << v
    end
    assert_equal([0, 4], result)
  end
  
  test 'each_input' do
    pipeline = EachElement.new([[1, 2], [3, 4]]) | EachInput.new 
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([1, 2, 3, 4], result)
  end
  
  test 'resume' do
    pipeline = EachElement.new(%w(foo bar)) | Restrict.new | EachInput.new{ |x| x.chars} | Resume.new
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([{ 'foo' => %w(f o o)}, {'bar' => %w(b a r)}], result)
  end
  
  test 'resume with count' do
    resume = ResumeCount.new
    pipeline = EachElement.new(%w(foo bar)) | Restrict.new | EachInput.new{ |x| x.chars} | Map.new{ |x| x.to_sym } | resume
    result = pipeline.run
    assert_equal({ 'foo' => { :f => 1, :o => 2}}, result)
  end
  
  test 'complex restrict' do
    gen = EachElement.new([{ :a => 1}, { :a => 2}])
    pipeline = gen | EachInput.new | Map.new{ |x| puts "x: #{x}"; x}| Restrict.new | Map.new{ |x| puts x; x} | Resume.new
    while pipeline.run
      puts 'end'
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
