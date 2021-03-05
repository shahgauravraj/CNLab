set ns [new Simulator]

set tf [open 04.tr w]
$ns trace-all $tf
set nf [open 04.nam w]
$ns namtrace-all $nf

set s [$ns node]
set c [$ns node]

$ns duplex-link $s $c 10Mb 22ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0
$tcp0 set packetSize_ 1500
set sink0 [new Agent/TCPSink]
$ns attach-agent $c $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$tcp0 set fid_ 1

proc finish { } {
	global ns tf nf 
	$ns flush-trace
	close $tf
    close $nf
    exec nam 04.nam &
	exec awk -f 04t.awk 04.tr &
	exec awk -f 04c.awk 04.tr > convert.tr &
	exec xgraph convert.tr -geometry 800*400 -t "bytes_received_at_client" -x "time_in_secs" -y "bytes_in_bps"  &
}
$ns at 0.01 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"
$ns run