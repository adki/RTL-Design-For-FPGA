#--------------------------------------------------------
# CLOCK
set_property PACKAGE_PIN Y9 [get_ports BOARD_CLK_IN] ;# 100Mhz
set_property IOSTANDARD LVCMOS33 [get_ports BOARD_CLK_IN]

#--------------------------------------------------------
# BOARD RESET
set_property PACKAGE_PIN P16      [get_ports BOARD_RST_SW] ;#BTNC
set_property IOSTANDARD  LVCMOS25 [get_ports BOARD_RST_SW]

#--------------------------------------------------------
set_false_path -reset_path       -from         [get_ports BOARD_RST_SW]
create_clock   -name BOARD_CLK_IN -period  10.0 [get_ports BOARD_CLK_IN]

