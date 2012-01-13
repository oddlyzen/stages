require 'stage_base'
Dir["#{File.dirname(__FILE__)}/stages/*.rb"].each { |file| require file.gsub(".rb", "")}

