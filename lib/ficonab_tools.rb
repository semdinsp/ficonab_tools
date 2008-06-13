#$:.unshift File.dirname(__FILE__)
Dir[File.join(File.dirname(__FILE__), 'ficonab_tools/**/*.rb')].sort.each { |lib| require lib }
module FiconabTools
  
end