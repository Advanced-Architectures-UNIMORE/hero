# connect -host 127.0.0.1 -port 31212
connect -host 155.185.4.26 -port 31212

puts -nonewline "Reseting" 
targets -set -nocase -filter {name =~ "*PSU*"}
stop
rst -system
after 2000
targets -set -nocase -filter {name =~ "*PMU*"}
stop
rst -system
after 2000
targets -set -nocase -filter {name =~ "*PSU*"}
stop
rst -system
after 2000
mwr 0xFFCA0038 0x1ff
targets -set -nocase -filter {name =~ "*MicroBlaze PMU*"}
dow "zcu102/images/linux/pmufw.elf"
after 2000
con

exit
