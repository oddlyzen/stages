require 'helper'
include Stages

class TestPipeline < MiniTest::Unit::TestCase
  
  test 'simple basic pipeline' do
    evens = Evens.new
    mx3 = Select.new{ |x| x % 3 == 0}
    mx7 = Select.new{ |x| x % 7 == 0}
    mx3.source = evens 
    mx7.source = mx3
    
    result = (0..2).map{ mx7.run }
    assert_equal([0, 42, 84], result)
  end
  
  test 'pipeline pipe syntax works' do
    pipeline = Evens.new | Select.new{ |x| x % 3 == 0} | Select.new{ |x| x % 7 == 0}
    result = (0..2).map{ pipeline.run }
    assert_equal([0, 42, 84], result)
  end
  
  test 'block stages work' do
    pipeline = Evens.new | Map.new{ |x| x * 3} | Select.new{ |x| x % 7 == 0}
    result = (0..2).map{ pipeline.run }
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
    pipeline = Each.new([1, 2, nil, 3])
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([1, 2], result)    
  end    
  
  test 'complex substage hash example' do
    sub = Each.new{ |x| x.chars } | Map.new{ |x| x.to_sym} | Count.new
    pipeline = Each.new(%w(foo bar)) | Wrap.new(sub) | Map.new{ |x| { x.keys.first => x.values.first.first}}
    result = pipeline.run
    assert_equal({'foo' => { :f => 1, :o => 2}}, result)
    result = pipeline.run
    assert_equal({ 'bar' => { :b => 1, :a => 1, :r => 1}}, result)
  end
  
  test 'reset! resets everything' do
    assert false
    #todo
  end

end
