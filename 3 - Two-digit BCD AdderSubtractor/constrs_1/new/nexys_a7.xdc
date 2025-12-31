## Clock signal
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## Reset (connect to a button)
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { add_sub }];

## Switches (SW[0] to SW[15]) - All 16 switches
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { sw[4] }];
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { sw[5] }];
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { sw[6] }];
set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [get_ports { sw[7] }];
set_property -dict { PACKAGE_PIN T8  IOSTANDARD LVCMOS33 } [get_ports { sw[8] }];
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports { sw[9] }];
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { sw[10] }];
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [get_ports { sw[11] }];
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports { sw[12] }];
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { sw[13] }];
set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports { sw[14] }];
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports { sw[15] }];

## SSD Anodes (AN[0] to AN[3])
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[3] }] ;# AN3
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[2] }] ;# AN2
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[1] }] ;# AN1
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes[0] }] ;# AN0

## SSD Cathodes (CA, CB, CC, etc.)
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[6] }] ;# CA (A)
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[5] }] ;# CB (B)
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[4] }] ;# CC (C)
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[3] }] ;# CD (D)
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[2] }] ;# CE (E)
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[1] }] ;# CF (F)
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathodes[0] }] ;# CG (G)

set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[0] }] ;# AN4
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[1] }] ;# AN5  
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[2] }] ;# AN6
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { ssd_anodes_unused[3] }] ;# AN7