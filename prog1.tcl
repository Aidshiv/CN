#TCL Program:

set ns [new Simulator]

set ntrace [open prog1.tr w]

$ns trace-all $ntrace

set namfile [open prog1.nam w]

$ns namtrace-all $namfile

#Finish Procedure

proc Finish {} {

global ns ntrace namfile

$ns flush-trace

close $ntrace

close $namfile

exec nam prog1.nam &

#show the number of packets dropped

exec echo “The number of packets dropped is ” &

exec grep -c “^d” prog1.tr &

exit 0

}

# create 3 nodes

set n0 [$ns node]

set n1 [$ns node]

set n2 [$ns node]

#Label the nodes

$n0 label "TCP Source"

$n2 label "Sink"

#Set the color

$ns color 1 blue

#Create Links between nodes

#You need to modify the bandwidth to observe the variation in packet drop

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

$ns duplex-link $n1 $n2 0.5Mb 10ms DropTail

#Make the Link Orientation

$ns duplex-link-op $n0 $n1 orient right

$ns duplex-link-op $n1 $n2 orient right

#Set Queue Size

#You can modify the queue length as well to observe the variation in packet drop

$ns queue-limit $n0 $n1 10

$ns queue-limit $n1 $n2 10

#2 protocols needed between 2 nodes i.e transaport layer and application layer

#Set up a Transport layer connection -

set tcp0 [new Agent/TCP] 

$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]

$ns attach-agent $n2 $sink0

$ns connect $tcp0 $sink0

#Set up an Application layer Traffic

set cbr0 [new Application/Traffic/CBR]

$cbr0 set type_ CBR

$cbr0 set packetSize_ 100

$cbr0 set rate_ 1Mb

$cbr0 set random_ false

$cbr0 attach-agent $tcp0

$tcp0 set class_ 1

#Schedule Events

$ns at 0.0 "$cbr0 start"

$ns at 5.0 "Finish"

$ns run
#######################################
#Input:

#ns prog1.tcl

 

#Output:

#Observe NAM window
#Trace file will be generated

###########################################
#AWK file:
###########################################

BEGIN{

c=0;

}

{

if($1=="d")

{

c++;

printf("%s\t%s\n",$5,$11);

}

}

END{

printf("the num of pkt dropped=%d\n",c);


}
