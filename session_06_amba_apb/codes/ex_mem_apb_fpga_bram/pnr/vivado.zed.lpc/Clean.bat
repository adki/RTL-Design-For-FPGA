@echo off
IF EXIST *.log DEL /Q *log
IF EXIST *.tcf       DEL   /q     *.tcf
IF EXIST *.rbt       DEL   /q     *.rbt
IF EXIST *.ncd       DEL   /q     *.ncd
IF EXIST *.ngd       DEL   /q     *.ngd
IF EXIST *.ngc       DEL   /q     *.ngc
IF EXIST *.ngm       DEL   /q     *.ngm
IF EXIST *.ptwx      DEL   /q     *.ptwx
IF EXIST *.ngo           DEL   /q     *.ngo
IF EXIST *.ise           DEL   /q     *.ise
IF EXIST *.twr           DEL   /q     *.twr
IF EXIST netlist.lst     DEL   /q     netlist.lst
IF EXIST *.lso           DEL   /q     *.lso
IF EXIST *.xrpt          DEL   /q     *.xrpt
IF EXIST xlnx_auto_0_xdb RMDIR /s /q  xlnx_auto_0_xdb
IF EXIST xst             RMDIR /s /q  xst
IF EXIST _xmsgs          RMDIR /s /q  _xmsgs

IF EXIST *.pad         DEL /q *.pad
IF EXIST *.bgn         DEL /q *.bgn
IF EXIST *.bld         DEL /q *.bld
IF EXIST *.drc         DEL /q *.drc
IF EXIST *.mrp         DEL /q *.mrp
IF EXIST *.par         DEL /q *.par
IF EXIST *.pcf         DEL /q *.pcf
IF EXIST *.xpi         DEL /q *.xpi
IF EXIST *_pad.csv     DEL /q *_pad.csv
IF EXIST *_pad.txt     DEL /q *_pad.txt
IF EXIST *_summary.xml DEL /q *_summary.xml
IF EXIST *_usage.xml   DEL /q *_usage.xml
IF EXIST *.unroutes    DEL /q *.unroutes
IF EXIST *.map         DEL /q *.map        

IF EXIST impact_impact.xwbt  DEL /q  impact_impact.xwbt
IF EXIST impact.xsl          DEL /q  impact.xsl        
IF EXIST webtalk.log         DEL /q  webtalk.log       

IF EXIST par_usage_statistics.html     DEL /q  par_usage_statistics.html    
IF EXIST *.xwbt      DEL /q  *.xwbt
IF EXIST webtalk.log                   DEL /q  webtalk.log
IF EXIST usage_statistics_webtalk.html DEL /q  usage_statistics_webtalk.html
IF EXIST xilinx_device_details.xml     DEL /q  xilinx_device_details.xml

