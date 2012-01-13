# -*- coding: utf-8 -*-
require 'bundler/setup'
Bundler.require(:default, :test)
require 'stages'
require 'turn'
require 'minitest/unit'

class MiniTest::Unit::TestCase
  def self.test(name, &block)
    define_method 'test_' + name, &block
  end
end

class MiniTest::Unit
  alias :run_test_suites_old :run_test_suites
  def run_test_suites(filter = /./)
    @test_count, @assertion_count = 0, 0
    old_sync, @@out.sync = @@out.sync, true if @@out.respond_to? :sync=
      TestCase.test_suites.each do |suite|
      test_cases = suite.test_methods.grep(filter)
      if test_cases.size > 0
        @@out.print "\n#{suite}:\n"
      end
      
      test_cases.each do |test|
        inst = suite.new test
        inst._assertions = 0
        
        
        @broken = nil

        @@out.print(case run_one inst
                    when :pass
                      @broken = false
                      green { "P" }
                    when :error
                      @broken = true
                      @@out.puts
                      yellow { pad_with_size "ERROR" }
                    when :fail
                      @broken = true
                      @@out.puts
                      red { pad_with_size "FAIL" }
                    when :skip
                      @broken = false
                      cyan { "S" }
                    when :timeout
                      @broken = true
                      @@out.puts
                      cyan { pad_with_size "TIMEOUT" }
                    end)

        if @broken
          @@out.print MiniTest::Unit.use_natural_language_case_names? ? 
          " #{test.gsub("test_", "").gsub(/_/, " ")}" : " #{test}"
          @@out.print " (%.2fs) " % @elapsed
          @@out.puts

          report = @report.last
          @@out.puts pad(report[:message], 10)
          trace = MiniTest::filter_backtrace(report[:exception].backtrace).first
          @@out.print pad(trace, 10)

          @@out.puts
        end

        # @@out.puts
        @test_count += 1
        @assertion_count += inst._assertions
      end
    end
    @@out.sync = old_sync if @@out.respond_to? :sync=
      [@test_count, @assertion_count]
  end
  
  def run_one(inst)
    t = Time.now
    result = inst.run self
    @elapsed = Time.now - t
    if result == :pass && @elapsed > 5.0
      result = :timeout
      @report << { :message => "Test took a long time (%.2fs)" % @elapsed, 
      :exception => Exception.new("Long test")}
    end
    result
  end
end

