require 'bundler/setup'
Bundler.require(:default, :test)
require 'minitest/unit'
Dir["#{File.dirname(__FILE__)}/../*.rb"].each {  |file| require file.gsub(".rb", "")}
Dir["#{File.dirname(__FILE__)}/../stages/*.rb"].each { |file| require file.gsub(".rb", "")}
include Pipeline

MiniTest::Unit.autorun
class TestPipeline < MiniTest::Unit::TestCase
  
  def test_basic
    evens = Evens.new
    mx3 = MultiplesOf.new(3)
    mx7 = MultiplesOf.new(7) 
    mx3.source = evens 
    mx7.source = mx3
    
    result = (0..2).map{ |x| mx7.run }
    assert_equal([0, 42, 84], result)
  end
  
  def test_pipe_syntax
    pipeline = Evens.new | MultiplesOf.new(3) | MultiplesOf.new(7)
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([0, 42, 84], result)
  end
  
  def test_block_stages
    pipeline = Evens.new | Map.new{ |val| val * 3} | Map.new{ |val| val + 1}
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([1, 7, 13], result)
  end
  
  def test_block_select
    pipeline = Evens.new | Map.new{ |val| val * 3} | Select.new{ |val| val > 6} | Map.new{ |v| v+1}
    result = (0..2).map{ |x| pipeline.run }
    assert_equal([13, 19, 25], result)
  end
end
