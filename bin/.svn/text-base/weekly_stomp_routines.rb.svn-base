#!/usr/bin/env ruby
# == Synopsis
#   Routines to run weekly on site...
# == Usage
#   weekly_stomp_routines.rb
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
puts "resetting week statistics"
`stomp_message_send.rb -T '/topic/sms' -M stomp_RESET -b week`    



