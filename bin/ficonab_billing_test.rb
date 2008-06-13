#!/usr/bin/env ruby

count=0
trials=50
t=[]
   start_time= Time.now
1.upto(trials)  do 
       t << Thread.new {
          res=`jruby -S billing_topic_action.rb -T  billing -A get_account_details -m 639993130030 -h localhost`
            status = res.include?("creditLimit:")
            count +=1 if status
            puts res if !status
            puts "Status is #{status} count: #{count} #{res}"  }
        end
     
        puts "Start Time #{start_time}"
        t.each {|s| s.join }
         puts "End Time #{Time.now}"
         duration=Time.now - start_time
puts "Success count is #{count} out of trials #{trials} duraction #{duration} seconds"
exit!