setMode -bs
setCable -port auto
Identify -inferir
identifyMPM
assignFile -p 2 -file "../fpga.bit"
Program -p 2
exit
