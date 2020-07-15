########################################################
## USB Host Interface Signal
## zedboard FMC
########################################################
set_property PACKAGE_PIN M19  [get_ports "SL_DT[0]"]         
set_property PACKAGE_PIN M20  [get_ports "SL_DT[1]"]         
set_property PACKAGE_PIN N19  [get_ports "SL_DT[2]"]         
set_property PACKAGE_PIN N20  [get_ports "SL_DT[3]"]         
set_property PACKAGE_PIN P17  [get_ports "SL_DT[4]"]         
set_property PACKAGE_PIN P18  [get_ports "SL_DT[5]"]         
set_property PACKAGE_PIN N22  [get_ports "SL_DT[6]"]         
set_property PACKAGE_PIN P22  [get_ports "SL_DT[7]"]         
set_property PACKAGE_PIN M21  [get_ports "SL_DT[8]"]         
set_property PACKAGE_PIN M22  [get_ports "SL_DT[9]"]         
set_property PACKAGE_PIN J18  [get_ports "SL_DT[10]"]        
set_property PACKAGE_PIN K18  [get_ports "SL_DT[11]"]        
set_property PACKAGE_PIN L21  [get_ports "SL_DT[12]"]        
set_property PACKAGE_PIN L22  [get_ports "SL_DT[13]"]        
set_property PACKAGE_PIN T16  [get_ports "SL_DT[14]"]        
set_property PACKAGE_PIN T17  [get_ports "SL_DT[15]"]        
set_property PACKAGE_PIN J16  [get_ports "SL_DT[16]"]
set_property PACKAGE_PIN J17  [get_ports "SL_DT[17]"]
set_property PACKAGE_PIN J20  [get_ports "SL_DT[18]"]
set_property PACKAGE_PIN K21  [get_ports "SL_DT[19]"]
set_property PACKAGE_PIN B19  [get_ports "SL_DT[20]"]
set_property PACKAGE_PIN B20  [get_ports "SL_DT[21]"]
set_property PACKAGE_PIN D20  [get_ports "SL_DT[22]"]
set_property PACKAGE_PIN C20  [get_ports "SL_DT[23]"]
set_property PACKAGE_PIN G15  [get_ports "SL_DT[24]"]
set_property PACKAGE_PIN G16  [get_ports "SL_DT[25]"]
set_property PACKAGE_PIN G20  [get_ports "SL_DT[26]"]
set_property PACKAGE_PIN G21  [get_ports "SL_DT[27]"]
set_property PACKAGE_PIN E20  [get_ports "SL_DT[28]"]
set_property PACKAGE_PIN G19  [get_ports "SL_DT[29]"]
set_property PACKAGE_PIN F19  [get_ports "SL_DT[30]"]
set_property PACKAGE_PIN E15  [get_ports "SL_DT[31]"]

set_property PACKAGE_PIN K19  [get_ports "SL_AD[1]"]        
set_property PACKAGE_PIN K20  [get_ports "SL_AD[0]"]        

set_property PACKAGE_PIN J21  [get_ports "SL_PCLK"]       
set_property PACKAGE_PIN J22  [get_ports "SL_CS_N"]       
set_property PACKAGE_PIN R20  [get_ports "SL_WR_N"]          
set_property PACKAGE_PIN R21  [get_ports "SL_OE_N"]          
set_property PACKAGE_PIN R19  [get_ports "SL_RD_N"]          
set_property PACKAGE_PIN T19  [get_ports "SL_FLAGA"] ;# LA10_N
set_property PACKAGE_PIN N17  [get_ports "SL_FLAGB"] ;# LA11_P
set_property PACKAGE_PIN N18  [get_ports "SL_FLAGC"] ;# LA11_N
set_property PACKAGE_PIN P21  [get_ports "SL_FLAGD"] ;# LA12_N

set_property PACKAGE_PIN P20  [get_ports "SL_PKTEND_N"]      
set_property PACKAGE_PIN L17  [get_ports "SL_RST_N"]         

set_property PACKAGE_PIN M17  [get_ports "SL_MODE[0]"] ;# LA13_N
set_property PACKAGE_PIN E19  [get_ports "SL_MODE[1]"] ;# LA21_P

set_property IOSTANDARD LVCMOS25    [get_ports {SL_*}]
set_property SLEW       FAST        [get_ports {SL_*}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SL_MODE_IBUF[0]]

set_property IOB TRUE  [get_cells {u_dut/u_gpif2mst/SL_DT_O*}]
set_property IOB TRUE  [get_cells {u_dut/u_gpif2mst/SL_RD_N}]
set_property IOB TRUE  [get_cells {u_dut/u_gpif2mst/SL_WR_N}]
set_property IOB TRUE  [get_cells {u_dut/u_gpif2mst/SL_OE_N}]
set_property IOB TRUE  [get_cells {u_dut/u_gpif2mst/SL_PKTEND_N}]
set_property IOB TRUE  [get_cells {u_dut/u_gpif2mst/SL_AD*}]

