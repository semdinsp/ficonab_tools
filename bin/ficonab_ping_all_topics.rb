#!/usr/bin/env ruby
# == Synopsis
#   Routine to configure the CURE smsc
# == Usage
#   ficonab_config_cure_smsc.rb
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
 RDoc::usage if  arg_hash[:help]==true 

topics = %w(sms billing workflow test mms subscription)
start=Time.now
puts "Start time #{start}"
res = []
topics.each  { |t|  cmd = "`jruby -S ficonab_ping_test.rb #{t} 3`" 
                    puts "About to run #{cmd}"
                    res << eval(cmd)
                    }
stop=Time.now
duration =stop-start
puts "Finished pings #{duration}"
puts  "Result #{res.join(',').to_s}"
exit!



