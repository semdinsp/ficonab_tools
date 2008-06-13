#!/usr/bin/env jruby
# == Synopsis
#   Routines to test site configuration
# == Usage
#   ficonab_test_configuration.rb   --output should be 'ALL OK'
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
 
rubyforge_gems = %w(stomp  tmail  )
ficonab_gems = %w( simple_sms_services stomp_message  mmsc_manager smsc_manager subscription_manager billing_web_service)
@all_ok=true
def test_gem(name,src=nil)
  puts "checking gem: #{name} installed"
  source = "--source #{src}" if src!=nil
  begin
    gem name
    require name
  rescue LoadError => e
    puts "---- #{name} gem required"
    puts "---- install with the following command"
    puts "----- sudo gem install #{source} #{name}"
    @all_ok=false
  end
end

ficonab_gems.each { |g| 
test_gem(g,"http://www.ficonab.com:8808")
}
rubyforge_gems.each { |g| 
test_gem(g)
}


puts 'All OK' if @all_ok
puts 'Problems--- please resolve' if !@all_ok

   



