require File.dirname(__FILE__) + '/test_helper.rb'
require 'rubygems'
gem 'ficonab_tools'
require 'ficonab_tools'
class TestFiconabTools < Test::Unit::TestCase

  def setup
  end
  
  def test_truth
    assert true
  end
  def test_connection_manager
     a=FiconabTools::ConnectionManager.instance()
     a.setup(["sms"])
    assert a.my_connections.size == 1, "wrong number of connections"
    puts "connection manager #{a.inspect}"
    begin
     a.setup(["bad"])
      assert false, "bad place"
    rescue RuntimeError
       assert true, "in right place"
        assert a.my_connections.size == 0, "wrong number of connections"
    end
     a.setup(["sms", 'billing', 'mms', 'workflow', 'test'])
    assert a.my_connections.size == 5, "wrong number of connections"
    puts "connection manager #{a.inspect}"
    puts "connection manager #{a.inspect}"
  end
end
