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
    pipeline = Evens.new | Select.new{ |x| x % 3 == 0}
    result = (0..3).map{ pipeline.run }
    assert_equal([0, 6, 12, 18], result)
  end
  
  test 'each_element' do
    pipeline = Each.new([1, 2, 3])
    result = (0..2).map{ pipeline.run }
    assert_equal([1, 2, 3], result)
  end
  
  test 'hash_lookup' do
    pipeline = Each.new([:do, :re, :mi]) | Map.new{ |x| sing[x]}
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
    pipeline.reset
    while v = pipeline.run
      result << v
    end
    assert_equal([0, 4], result)
  end
  
  test 'resume' do
    pipeline = Each.new(%w(foo bar)) | Restrict.new | Each.new{ |x| x.chars} | Resume.new
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([{ 'foo' => %w(f o o)}, {'bar' => %w(b a r)}], result)
  end
  
  test 'resume with count' do
    resume = ResumeCount.new
    pipeline = Each.new(%w(foo bar)) | Restrict.new | Each.new{ |x| x.chars} | Map.new{ |x| x.to_sym } | resume
    result = pipeline.run
    assert_equal({ 'foo' => { :f => 1, :o => 2}}, result)
  end
  
  test 'hash mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars})
    result = pipeline.run
    assert_equal(%w(f o o), result['foo'])
    result = pipeline.run
    assert_equal(%w(b a r), result['bar'])
  end
  
  test 'hash/aggregated wrap mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars} | Count.new, :aggregated)
    result = pipeline.run
    assert_equal(2, result['foo']['o'])
    result = pipeline.run
    assert_equal(3, result['bar'].keys.length)
  end
  
  
  test 'array mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars}, :array)
    result = pipeline.run
    assert_equal(%w(f o o), result)
    result = pipeline.run
    assert_equal(%w(b a r), result)
  end
  
  test 'each mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars}, :each)
    expected = %w(r a b o o f)
    while r = pipeline.run
      assert_equal(expected.pop, r)
    end    
  end
  
  test 'unique' do
    pipeline = Each.new('abcadefbega'){ |x| x.chars} | Unique.new
    results = []
    while r = pipeline.run
      results << r
    end
    assert_equal(%w(a b c d e f g), results)
  end
  
  test 'exhaust' do
    pipeline = Each.new(%w(foo bar zut)) | Exhaust.new
    assert_equal(%w(foo bar zut), pipeline.run)
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
