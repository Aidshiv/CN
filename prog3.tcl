###########comments##############
#process how to run code 

#Step 1: Create trace files
Create files file1.tr and file2.tr.
Commands
set file1 [open file1.tr w]  
set file2 [open file2.tr w]

#Step 2: Attach files to agents
Attach file1.tr to tcp0 and file2.tr to tcp1.
Copy code
"$tcp0 attach $file1" 
"$tcp1 attach $file2"

#Step 3: Trace congestion window values
#Use the trace command to capture congestion window values for tcp0 and tcp1.

#Copy code
$tcp0 trace cwnd_  
$tcp1 trace cwnd_
#Store the values in file1.tr and file2.tr.

#Step 4: Plot the graph
#Use the following steps to generate and visualize the graph:
#Run the Tcl script:
#Copy code
ns prog3.tcl
#Process the trace files with awk:

#Copy code
awk -f prog3.awk file1.tr > tcp1  
awk -f prog3.awk file2.tr > tcp2

#Plot the graph using xgraph:
#Copy code 
xgraph -x “Time” -y “cwnd” tcp0 tcp2
################################
file 1:- filename.tcl
#########code ################

set ns [new Simulator] 
set nf [open lab3.nam w]
$ns namtrace-all $nf
set tf [open lab3.tr w]
$ns trace-all $tf
set n0 [$ns node] 
set n1 [$ns node] 
set n2 [$ns node] 
set n3 [$ns node]
$ns color 1 red
$ns color 2 blue 
#create LAN
$ns make-lan "$n0 $n1 $n2 $n3" 10Mb 10ms LL Queue/DropTail Mac/802_3
#Attach Agents
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0 
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp0 $sink3
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2 
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp2 $sink1
$tcp0 set class_ 1
$tcp2 set class_ 2

######To trace the congestion window##########

set file1 [open file1.tr w]
$tcp0 attach $file1
$tcp0 trace cwnd_
$tcp0 set maxcwnd_ 10
set file2 [open file2.tr w]
$tcp2 attach $file2
$tcp2 trace cwnd_
proc finish { } {
global nf tf ns
$ns flush-trace 
exec nam lab3.nam & 
close $nf 
close $tf 
exit 0
}
$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"
$ns at 2 "$ftp0 start"
$ns at 3 "$ftp0 stop"
$ns at 0.2 "$ftp2 start"
$ns at 2 "$ftp2 stop"
$ns at 2.5 "$ftp2 start"
$ns at 4 "$ftp2 stop"
$ns at 5.0 "finish"
$ns run
###############################
#Execution steps
#ns lab3.tcl
#awk -f lab3.awk file1.tr>tcp0
#awk -f lab3.awk file2.tr>tcp2
#xgraph –x “time” –y “convalue” tcp0 tcp2
###############################
file 2:- filename.awk
#############################
BEGIN{
#include<stdio.h>
}
{
if($6=="cwnd_")
printf("%f \t %f \n",$1,$7);
}
END{
puts "DONE"

}
