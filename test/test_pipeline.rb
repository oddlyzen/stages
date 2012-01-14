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

end
