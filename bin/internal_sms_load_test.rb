#!/usr/bin/env ruby
# == Synopsis
#   Internal load test command to drive a lot of messages at system
#   internal_sms_load_test.rb -u user -m msisdn -s source -t text  -c count -r count
# == Usage
#   internal_sms_load_test.rb -u scot -m 639993130030 -s 888 -t testing_load  -c 100 -r 10
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
arg_hash=StompMessage::Options.parse_options(ARGV)
 RDoc::usage if  arg_hash[:help]==true || arg_hash[:msisdn]==nil || arg_hash[:count]==nil || arg_hash[:repeat]==nil
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
     s=SmscManager::Sms.new(final_text,destination,source)
     sms_sender.send_topic_sms_receipt(s) { |m| receipt_count-=1
                                              #  puts "receipt: #{receipt_count}" 
                                                }
      #sleep(1) if c % 100 == 0   
      Thread.pass
    }
  
   # sms_sender.close_topic
        begin
       Timeout::timeout(count*0.75) {
            while true  
               puts "sent #{count} waiting for #{receipt_count} receipts"
               exit(0) if receipt_count==0   
               sleep(1)
               end  }
         rescue SystemExit
         
         rescue Exception => e
          puts "exception #{e.message} class: #{e.class}"
          puts  "#{e.backtrace}"
         # raise e 
        
         end
         receipt_count
end
    puts "Finding sms topic to use:"
    begin
      sms_sender=SmscManager::SmsSendTopic.new(arg_hash)    
      sms_sender.setup_auto_close
      # sms_sender.setup_auto_close   #only call this once  # servers onlycall cloase
   rescue Exception => e
      puts "exception found #{e.backtrace}" 
   end  
     
     repeat= arg_hash[:repeat].to_i
     count= arg_hash[:count].to_i
     start=Time.now
     puts "Time now: #{start}"
     no_receipt_count=0
     1.upto(repeat.to_i) { |r|
       no_receipt_count+=send_group(arg_hash,sms_sender)
     #  sleep(1)
       diff = Time.now - start
       puts "#{Time.now} Sent #{count*r} in #{diff} seconds with #{no_receipt_count} problems"
      
       completion = r.to_f/repeat.to_i*100
        puts "Percent complete: #{completion}"
        no_prob = count*r - no_receipt_count
        puts " Average message per second is: #{no_prob/diff}"
       }
             
        diff = Time.now - start
        no_prob = count*repeat.to_i - no_receipt_count
    	puts "#{Time.now} Sent #{count*repeat.to_i} in #{diff} seconds with #{no_receipt_count} problems";
    	puts " Average message per second is: #{no_prob/diff}"
    	
    	
       
    	exit!
    	
    # puts "Sending user: #{user} destination: #{destination}  text: #{text}"
   #  res= smsc.send(sms)
   #   puts "Response code: #{res.response} body: #{res.response_body}"  
   #  puts "Response code: #{res}"  if res.kind_of? String
   #  puts "pretty print response:"
  #   pp res
    # puts "Response code: #{res.} body: #{res.code}"  if res.kind_of? Net::Http
    
