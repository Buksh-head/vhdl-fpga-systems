## Clock (100 MHz)
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }]

## Switches -> switches[7:0]
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { switches[0] }] ;# SW0
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { switches[1] }] ;# SW1
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { switches[2] }] ;# SW2
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports { switches[3] }] ;# SW3
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { switches[4] }] ;# SW4
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { switches[5] }] ;# SW5
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { switches[6] }] ;# SW6
set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [get_ports { switches[7] }] ;# SW7

## Buttons
# Reset -> BTNC (centre)
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { reset }] ;# BTNC

# btn1 -> BTNL (left)
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { btn2 }] ;# BTNL

# btn2 -> BTNR (right)
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { btn1 }] ;# BTNR

## RGB LED (rgb_led[2:0] = {R,G,B})
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports { rgb_led[0] }] ;# LED16_R
set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports { rgb_led[1] }] ;# LED16_G
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports { rgb_led[2] }] ;# LED16_B

## Seven-seg cathodes (ssd_cathodes[6:0] = A..G), active-low
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[6] }] ;# CA (A)
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[5] }] ;# CB (B)
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[4] }] ;# CC (C)
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[3] }] ;# CD (D)
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[2] }] ;# CE (E)
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[1] }] ;# CF (F)
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[0] }] ;# CG (G)
# (DP is unused by your top)

## Seven-seg anodes (ssd_anodes[3:0] = AN3..AN0), active-low
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[3] }] ;# AN3
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[2] }] ;# AN2
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[1] }] ;# AN1
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[0] }] ;# AN0

## Disable unused seven-segment displays (AN4-AN7) - keep them always off (high since active-low)
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[0] }] ;# AN4
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[1] }] ;# AN5  
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[2] }] ;# AN6
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[3] }] ;# AN7