require 'yaml'
require 'erb'
require 'socket'
require 'rubygems'
require 'singleton'
#require 'stomp_server'
gem 'stomp_message'
require 'stomp_message'
module FiconabTools
class ServerManager
  include Singleton
  include StompMessage::JmsTools
  attr_accessor :my_servers
  def setup(needed_servers)
    self.my_servers = {}
    jms_start("TopicConnectionFactory")
    create_servers(needed_servers)
  end
  def create_servers(needed)
    needed.each {|c| # puts "creating server #{c}"
                     self.my_servers[c] = get_server_topic(c)}
  end
  #def closing_connections
  #  self.my_connections.each {|k,v|  v.send_topic_jms_shutdown
  #                              puts "closed connection #{k} "   }
  # end
  def get_server_topic(topic)
    s=nil
     params = { :topic => "#{topic.to_s}"}
      puts "creating server: #{topic.to_s}"
         params[:standalone]='true'
       tdest, tconn= jms_create_destination_connection( params[:topic])
       tproducer, tsession= jms_create_producer_session(tdest,tconn)
        tconsumer, consumer_session = jms_create_consumer_session(tdest,tconn) 
    case topic
      when   "billing"
        gem 'billing_web_service'
        require 'billing_web_service'  #specific requir a fix for clash with httpclient
        # require 'billing_web_service/billing_message'
     
         params[:jms_source]='bwsserver'
         s=BillingWebService::BillingServer.new(params)
         tlistener=StompMessage::MySpecialListener.new(s)   
         tconsumer.setMessageListener(tlistener)
      when "sms"
        gem 'smsc_manager'
        require 'smsc_manager'
         params[:jms_source]='smsserver'
         params[:env]='development' 
        s=SmscManager::SmscListener.new(params)
        tlistener=StompMessage::MySpecialListener.new(s)
        tconsumer.setMessageListener(tlistener)
       when "mms"
          gem 'mmsc_manager'
          require 'mmsc_manager'
            params[:jms_source]='mmsserver'
          s=MmscManager::MmscServer.new(params)  
           tlistener=StompMessage::MySpecialListener.new(s)
            tconsumer.setMessageListener(tlistener)
            puts "end of mms"
          when "subscription"
            puts "in sub_mgr"
              gem 'subscription_manager'
              require 'subscription_manager'
                params[:jms_source]='subcriptionserver'
                   params[:env]='development'  #remove jdbc pools
              s=SubscriptionManager::SubscriptionServer.new(params)  
               tlistener=StompMessage::MySpecialListener.new(s)
                tconsumer.setMessageListener(tlistener)
       when "workflow"
         puts "in workflow"
          gem 'workflow_manager'
          require 'workflow_manager'
            params[:jms_source]='workflowserver'
          params[:env]='development' 
          s=WorkflowManager::WorkflowServer.new(params)
          tlistener=StompMessage::MySpecialListener.new(s)
          tconsumer.setMessageListener(tlistener)
       when "test"
          gem 'stomp_message'
          require 'stomp_message'
      
             params[:jms_source]='testserver'
             s=StompMessage::StompServer.new(params)
              tlistener=StompMessage::MySpecialListener.new(s)
               tconsumer.setMessageListener(tlistener)
      else
        raise "bad topic in server manager #{topic}"
      end
      s
  end

end  # class connection manager
end  # module ficonab tools