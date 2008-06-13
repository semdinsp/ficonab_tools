#!/usr/bin/env ruby
# == Synopsis
#   Routines to run daily on site...
# == Usage
#   daily_stomp_routines.rb
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'optparse'
require 'rdoc/usage'
require 'rubygems'
gem 'subscription_manager'
require 'subscription_manager'
arg_hash=StompMessage::Options.parse_options(ARGV)
 RDoc::usage if  arg_hash[:help]==true

begin
  require 'stomp_message'
rescue LoadError => e
  puts '---- stomp message required'
  puts '---- install with the following command'
  puts '----- sudo gem install stomp_message'
    puts "----- exception message #{e.backtrace}" 
  exit(1)
end
#puts "get statistics report"
#`stomp_message_send.rb -T '/topic/sms' -M stomp_REPORT -b nil -A true -h localhost -D scott.sproule@cure.com.ph`
topics = %w(sms billing workflow test mms subscription)
start=Time.now
puts "Start time #{start}"
res = []
topics.each  { |t|  cmd = "`jruby -S stomp_message_send.rb -T #{t} -M stomp_PING -b nil -A true -h localhost -D scott.sproule@cure.com.ph`" 
                    puts "About to run #{cmd}"
                    res << eval(cmd)
                    }

#puts "resetting day statistics"
# `stomp_message_send.rb -T "/topic/sms" -M stomp_RESET -b day`    
exit!


