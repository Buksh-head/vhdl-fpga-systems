# FPGA Digital Systems Workbook

A staged FPGA design workbook exploring combinational logic, structural VHDL, datapath/FSM design, and DSP architectures (from simple truth-table logic through to spectrum sensing).

Targets: Xilinx/AMD Vivado + Digilent Nexys (A7 / Artix-7 class boards), with a mix of handwritten VHDL and model-based HDL generation.

## Projects

### 01 — 4-bit Prime Detector (combinational, dataflow VHDL)
Built a 4-input prime-number detector for values 0–15 using a truth table → K-map simplification → direct dataflow equation in VHDL.
Includes a self-checking testbench, optional output delay modelling, and synthesis inspection (purely combinational design).  
(Prime outputs: 2, 3, 5, 7, 11, 13).

### 02 — Two-digit BCD Comparator + SSD Multiplexing + RGB Status
Implemented a modular structural VHDL system with:
- 8-bit registers with clock-enable + reset (two operands)
- BCD validators per nibble (invalid digits show “E”)
- Comparator with match-type (no/partial/full) + per-digit match flags
- Seven-segment multiplexing (anode scanning + digit mux + hex→SSD mapping)
- RGB LED status (red=no match, green=full match, yellow=partial)
Tested via simulation and on-board validation with digit alignment fixes and display-bank handling.

### 03 — Two-digit BCD Adder/Subtractor (10’s complement subtraction)
Designed a modular BCD arithmetic unit:
- Digit-wise BCD correction (raw sum > 9 → +6 with carry)
- Subtraction via radix-10 (ten’s) complement
- Reuse of display scanning modules from earlier work
Verified in simulation and hardware with cases covering carry into hundreds and complement-style subtraction behaviour.

### 04 — GCD Engine (Datapath + FSM Controller)
Implemented a custom hardware GCD calculator for two 8-bit unsigned integers using the Euclidean algorithm with a classic datapath/controller split:
- Registers, muxes, subtractors, comparator, and binary→BCD display path
- Moore-style FSM states (IDLE/LOAD/CHECK/SUB/FINISH)
Validated with multiple test cases and reviewed utilisation (carry chains inferred by tools).

### 05 — FIR Filter on FPGA (MATLAB HDL Coder + Vivado)
Prototyped a 16-tap FIR filter from a Simulink model through HDL generation and FPGA implementation.
Compared unoptimised vs optimised architectures using:
- pipelining, retiming, and data broadcasting
- fixed-point word-length exploration (e.g., W=24, D≈10–12)
Reported timing/resource trade-offs (critical path reduction and improved slack) and hardware co-simulation evidence.

### 06 — Low-complexity Spectrum Sensing (8-point Approximate DFT)
Implemented and verified an 8-point Approximate DFT (ADFT) for spectrum sensing:
- software validation with exact-bin tones, DC offset, and off-bin leakage cases
- fixed-point Simulink implementation → HDL generation → FPGA-in-the-loop verification
- pipelining inserted to reduce combinational depth and improve Fmax
Also drafted a proposed standalone top-level architecture integrating ROM sources, SIPO framing, energy computation, and SSD visualisation.

## Notes
Each folder contains the source, testbenches (where applicable), constraints, and short notes on key design decisions + verification steps.
