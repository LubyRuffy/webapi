#!/usr/bin/ruby 
#

loop do 
  process = `ps -ef | grep arachni_rest_server | grep -v 'grep'`
  if process.empty?
    puts("no arachni running.")
    system('/home/venus/arachni-2.0dev-1.0dev/bin/arachni_rest_server --address 0.0.0.0 > /dev/null 2>&1 &')
  end
  sleep(1)
  puts("I'm alive")
end
