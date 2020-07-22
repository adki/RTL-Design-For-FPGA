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

#--------------------------------------------------------
#set_property PACKAGE_PIN P16 [get_ports {BTNC}];  # "BTNC" // used for board rst
set_property PACKAGE_PIN R16 [get_ports {BTND}];  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {BTNL}];  # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {BTNR}];  # "BTNR"
set_property PACKAGE_PIN T18 [get_ports {BTNU}];  # "BTNU"
set_property IOSTANDARD LVCMOS25 [get_ports BTN?]

#--------------------------------------------------------
set_property PACKAGE_PIN T22 [get_ports {LD0}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {LD1}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {LD2}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {LD3}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"
set_property IOSTANDARD LVCMOS33 [get_ports LD?]

