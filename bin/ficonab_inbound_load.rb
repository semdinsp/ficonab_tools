#!/usr/bin/env jruby
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
include StompMessage::JmsTools
count=0
trials= ARGV[1] ||=1
t=[]
puts "usage:  ficonab_ping_test topic  count   eg:  ficonab_ping_test sms 40" 
puts "Current directory: "+`pwd` + " argv is:" + ARGV[0]   # argv should be topic
puts "topic is: #{ARGV[0]} count is:#{trials}"
   start_time= Time.now
    jms_start("TopicConnectionFactory")
    dest, conn, session = jms_create_session("#{ARGV[0]}")
    producer = jms_create_producer(session,dest)
    consumer = jms_create_consumer(session,dest)
    msg=StompMessage::Message.new('stomp_PING','nil')
        duration=Time.now - start_time
puts "Setup_duration topic #{ARGV[0]}  #{duration} seconds"
        start_time= Time.now
1.upto(trials.to_i)  do |index|
       t << Thread.new { 
          msg=StompMessage::Message.new('stomp_PING',"ping #{index}")
          res=jms_send_message(session,producer,{},msg.to_xml) 
           # status = res.include?("ALIVE")
            count +=1 #if status
          #  puts res if !status
            puts "Status is  count: #{count} #{res}"  }
        end
        jms_shutdown(dest,conn,session,producer,consumer)
        puts "Start Time #{start_time}"
        t.each {|s| s.join }
         puts "End Time #{Time.now}"
         duration=Time.now - start_time
puts "Success count topic #{ARGV[0]} is #{count} out of trials #{trials} sending duration #{duration} seconds"
exit!