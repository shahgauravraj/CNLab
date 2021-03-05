BEGIN {
     last = 0
     tcp_sz = 0
     cbr_sz = 0
     total_sz = 0
}
{ 
    if ($5 == "tcp" && $1 == "r" && $4 == "3" ) 
        tcp_sz += $6
    if ($5 == "cbr" && $1 == "r" && $4 == "3" ) 
        cbr_sz += $6
    total_sz += $5
 }
END {
    print time, ( tcp_sz * 8 / 1000000)
    print time , (cbr_sz * 8 / 1000000 ), ( total_sz * 8 / 1000000)
 }