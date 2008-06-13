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



puts "setting cure smsc settings to: host  10.43.31.192 user pass port: 26006"
`jruby -S smsc_config.rb 10.43.31.192 cure cur3 26006` 
puts `jruby -S smsc_print_config.rb`    



