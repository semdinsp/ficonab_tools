#!/usr/bin/env jruby
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
include StompMessage::JmsTools
count=0
trials= ARGV[1] ||=1
t=[]
puts "usage:  ficonab_ping_test topic  count repeat   eg: jruby -J-server -J-Djruby.thread.pooling=true  ficonab_ping_test sms 40" 
puts "Current directory: "+`pwd` + " argv is:" + ARGV[0]   # argv should be topic
puts "topic is: #{ARGV[0]} count is:#{trials}"
   start_time= Time.now
    jms_start("TopicConnectionFactory")
   # dest, conn, session = jms_create_session("#{ARGV[0]}")
   # producer = jms_create_producer(session,dest)
   # consumer = jms_create_consumer(session,dest)
    tdest, tconn= jms_create_destination_connection( "#{ARGV[0]}")
     producer, session= jms_create_producer_session(tdest,tconn)
     consumer, consumer_session = jms_create_consumer_session(tdest,tconn)
    msg=StompMessage::Message.new('stomp_PING','nil')
        duration=Time.now - start_time
puts "Setup_duration topic #{ARGV[0]}  #{duration} seconds"
repeat =1
repeat = ARGV[2].to_i if ARGV[2]!=nil
  my_guard    = Mutex.new  
        grand_start_time = Time.now
  1.upto(repeat) do |r|
        start_time= Time.now
    1.upto(trials.to_i)  do |index|
       t << Thread.new { 
          msg=StompMessage::Message.new('stomp_PING',"ping #{index}")
          xml_msg=''
          my_guard.synchronize {    xml_msg=msg.to_xml }
          res=jms_send_ack(session,producer,xml_msg) 
            status = res.include?("ALIVE")
            count +=1 if status
            puts res if !status
            puts "Status is #{status} count: #{count} #{res}"  }
        end
     
        puts "Start Time #{start_time}"
        t.each {|s| s.join }
         puts "End Time #{Time.now}"
         duration=Time.now - start_time
         puts "Success count topic #{ARGV[0]} is #{count} out of trials #{trials} sending duration #{duration} seconds"
         
    end
        big_duration=Time.now - grand_start_time
          puts "Success count topic #{ARGV[0]} is #{count}  sending duration #{big_duration} seconds"
        puts "Average msg/second #{count/big_duration} [Success] "
       consumer_session.close
       jms_shutdown(tdest, tconn, session, producer, consumer)
       exit!
      