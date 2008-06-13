#!/usr/bin/env jruby
# == Synopsis
#   Internal load test command to drive a lot of messages at system
#   jms_sms_load_test.rb -u user -m msisdn -s source -t text  -c count -r count -T topic
# == Usage
#   jruby -S jms_sms_load_test.rb -u scot -m 639993130030 -s 999 -t testing_load  -c 100 -r 10 -T sms
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'optparse'
require 'rdoc/usage'
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
require 'java'
include StompMessage::JmsTools
arg_hash=StompMessage::Options.parse_options(ARGV)
 RDoc::usage if  arg_hash[:help]==true || arg_hash[:count]==nil || arg_hash[:repeat]==nil
gem 'smsc_manager'
require 'smsc_manager'
def send_group(arg_hash,sms_sender)
  user=arg_hash[:user]
   destination=arg_hash[:msisdn]
   source=arg_hash[:source]
   text=arg_hash[:text]
   count=arg_hash[:count].to_i
   
    receipt_count=count
   1.upto(count) { |c| 
     puts "sent #{c} messages" if c % 100 == 0   
       final_text = "count: #{c}: #{text} "
      
        result =sms_sender.send_sms(final_text,destination,source) 
                                              
    }
  
  
end
    puts "Finding sms topic to use:"
   
      sms_sender=SmscManager::SmsSendTopic.new(arg_hash)    
  
     
     repeat= arg_hash[:repeat].to_i
     count= arg_hash[:count].to_i
     puts "count is #{count} repeat is #{repeat}"
     start=Time.now
     puts "Time now: #{start}"
     no_receipt_count=0
   #   jms_start("TopicConnectionFactory")
    #  dest, conn, @session = sms_sender.jms_create_session( arg_hash[:topic])
   #   @producer = jms_create_producer(@session,dest)
     # consumer = jms_create_consumer(@session,dest)
     1.upto(repeat.to_i) { |r|
       no_receipt_count+=send_group(arg_hash,sms_sender)
     #  sleep(1)
       diff = Time.now - start   
       completion = r.to_f/repeat.to_i*100
        puts "#{Time.now} Sent #{count*r} in #{diff} seconds.  Percent complete: #{completion}"
        no_prob = count*r  # - no_receipt_count
        puts " Average message per second is: #{no_prob/diff}"
       }
             
        diff = Time.now - start
      #  no_prob = count*repeat.to_i - no_receipt_count
    	puts "#{Time.now} Sent #{count*repeat.to_i} in #{diff} seconds "
    	puts " Average message per second is: #{count*repeat.to_i/diff}"
    	  sms_sender.send_topic_jms_shutdown 
    	
    	
       
    	exit!
    	
    # puts "Sending user: #{user} destination: #{destination}  text: #{text}"
   #  res= smsc.send(sms)
   #   puts "Response code: #{res.response} body: #{res.response_body}"  
   #  puts "Response code: #{res}"  if res.kind_of? String
   #  puts "pretty print response:"
  #   pp res
    # puts "Response code: #{res.} body: #{res.code}"  if res.kind_of? Net::Http
    
