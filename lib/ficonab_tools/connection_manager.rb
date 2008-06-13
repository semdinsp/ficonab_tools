require 'yaml'
require 'erb'
require 'socket'
require 'rubygems'
require 'singleton'
#require 'stomp_server'
gem 'stomp_message'
require 'stomp_message'
module FiconabTools
class ConnectionManager
  include Singleton
  attr_accessor :my_connections
  def setup(needed_connections)
    self.my_connections = {}
    create_connections(needed_connections)
  end
  def create_connections(needed)
    needed.each {|c| puts "creating connection #{c}"
                     self.my_connections[c] = get_send_topic(c)}
  end
  def closing_connections
    self.my_connections.each {|k,v|  v.send_topic_jms_shutdown
                                puts "closed connection #{k} "   }
  end
  def get_send_topic(topic)
    a=nil
     params = { :topic => "#{topic.to_s}"}
      puts "creating topic: #{topic.to_s}"
    case topic
      when   "billing"
        gem 'billing_web_service'
        require 'billing_web_service/billing_send_topic'  #specific requir a fix for clash with httpclient
        require 'billing_web_service/billing_message'
        a=BillingWebService::BillingSendTopic.new(params)
      when "sms"
        gem 'smsc_manager'
        require 'smsc_manager'
        a=SmscManager::SmsSendTopic.new(params)
       when "mms"
          gem 'mmsc_manager'
          require 'mmsc_manager'
          a=MmscManager::MmsSendTopic.new(params)  
       when "workflow"
          gem 'workflow_manager'
          require 'workflow_manager'
          a=WorkflowManager::WorkflowSendTopic.new(params)
       when "test"
          gem 'stomp_message'
          require 'stomp_message'
          a=StompMessage::StompSendTopic.new(params)
      else
        raise "bad topic in connection manager #{topic}"
      end
      a
  end

end  # class connection manager
end  # module ficonab tools