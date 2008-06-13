#!/usr/bin/env jruby
# == Synopsis
#   Setup system servers
#   jruby -S jms_servers.rb -T 'comma separate list of topics'
# == Usage
#   jruby -S jms_servers.rb -T 'test,billing,sms,mms,workflow,subscription'
# NOTE THAT billing and workflow can not be together
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'optparse'
require 'rdoc/usage'
require 'rubygems'
gem 'ficonab_tools'
require 'stomp_message'
require 'java'
include StompMessage::JmsTools
arg_hash=StompMessage::Options.parse_options(ARGV)
 RDoc::usage if  arg_hash[:help]==true
gem 'ficonab_tools'
require 'ficonab_tools'


      
       trap("INT")   {  puts "#{Time.now}: #{self.class} in interrupt trap\n"
                         #close_topic
                         #disconnect_stomp
                         #setup_auto_close   already done in INIT
                        # jms_close_connections
                         exit! }
    my_servers=FiconabTools::ServerManager.instance()
    
    server_list =arg_hash[:topic].split(',')
    puts "server list: #{server_list.to_s} -T is #{arg_hash[:topic]}"
    # ['test', 'billing', 'sms', 'mms', 'workflow' ,'subscription']
    
    my_servers.setup(server_list)
    	
    # puts "Sending user: #{user} destination: #{destination}  text: #{text}"
   #  res= smsc.send(sms)
   #   puts "Response code: #{res.response} body: #{res.response_body}"  
   #  puts "Response code: #{res}"  if res.kind_of? String
   #  puts "pretty print response:"
  #   pp res
    # puts "Response code: #{res.} body: #{res.code}"  if res.kind_of? Net::Http
    
