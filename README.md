# 32-bit RISC-V RV32I Processor Core Using Verilog HDL

A software-based RTL design and functional verification project implementing a 32-bit RISC-V processor core using Verilog HDL.

# Project Overview

This project implements a 32-bit single-cycle RISC-V processor core using modular Verilog RTL.

The processor was designed with separate modules for the program counter, instruction memory, register file, ALU, control unit, immediate generator, and data memory. A dedicated Verilog testbench was developed to verify the processor functionality through simulation.

The project was simulated using Icarus Verilog and the generated VCD waveform was analyzed using GTKWave.

Note: This project implements a selected RV32I instruction subset for educational RTL design and functional verification. It is not intended to claim complete RV32I ISA compliance.


# Processor Architecture

The processor consists of the following major RTL blocks:

- Program Counter (PC)
- Instruction Memory
- Instruction Decoder
- Control Unit
- Register File
- Immediate Generator
- ALU
- Data Memory
- Branch Decision Logic
- Jump and Link Logic
- Write-back Logic
- Next-PC Selection Logic


# Basic Datapath

'
                    ┌─────────────────┐
                    │ Program Counter │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Instruction     │
                    │ Memory          │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Instruction     │
                    │ Decoder        │
                    └───────┬─────────┘
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
       ┌────────────┐ ┌────────────┐ ┌──────────────┐
       │ Register   │ │ Immediate  │ │ Control Unit │
       │ File       │ │ Generator  │ │              │
       └─────┬──────┘ └─────┬──────┘ └──────┬───────┘
             │              │               │
             └──────────────┼───────────────┘
                            ▼
                     ┌────────────┐
                     │    ALU     │
                     └─────┬──────┘
                           │
                  ┌────────┴────────┐
                  ▼                 ▼
           ┌────────────┐    ┌─────────────┐
           │ Data       │    │ Write-back  │
           │ Memory     │    │ Logic       │
           └────────────┘    └──────┬──────┘
                                    │
                                    ▼
                              Register File
                              
# Implemented Instruction Subset

The processor currently implements the following selected instructions:
Type	Instructions
R-type	ADD, SUB, AND, OR, XOR
I-type	ADDI
Load/Store	LW, SW
Branch	BEQ, BNE
Jump	JAL


# RTL Modules

The rtl/ directory contains the processor implementation:
Module	Function
pc.v	Program counter
instruction_memory.v	Instruction storage and instruction selection
register_file.v	Register read/write operations
alu.v	Arithmetic and logical operations
immediate_generator.v	Immediate value generation
control_unit.v	Instruction control signal generation
data_memory.v	Load/store data memory
riscv_core.v	Top-level processor core integration


# Verification

A dedicated testbench is provided in:
tb/tb_riscv_core.v
The testbench verifies important processor operations including:
- ADDI
- ADD
- SUB
- BEQ
- JAL
The simulation also generates a VCD waveform file for signal-level verification.


# Verification Results

==============================================
RISC-V PROCESSOR VERIFICATION
==============================================

[PASS] ADDI : x1 = 10
[PASS] ADDI : x2 = 20
[PASS] ADD  : x3 = 30
[PASS] SUB  : x4 = 20
[PASS] BEQ  : branch taken, x5 instruction skipped
[PASS] BEQ  : branch target executed, x6 = 55
[PASS] JAL  : x7 = PC + 4 = 32
[PASS] JAL  : jump target reached, x8 instruction skipped

=========================================================
                VERIFICATION COMPLETE
=========================================================

All listed verification checks passed successfully in the final simulation.

# Waveform Analysis

The generated waveform is stored in:
waveforms/riscv_core.vcd
GTKWave was used to analyze important processor signals including:
- Clock
- Reset
- Program Counter
- Instruction
- ALU Result
- Branch
- Branch Taken
- Jump
- Next PC
- 
The waveform demonstrates sequential instruction execution as well as changes in the next-PC path during branch and jump operations.

# Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Visual Studio Code
- GitHub

# Repository Structure

riscv-rv32i-verilog-processor/
│
├── README.md
│
├── rtl/
│   ├── README.md
│   ├── alu.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── immediate_generator.v
│   ├── instruction_memory.v
│   ├── pc.v
│   ├── register_file.v
│   └── riscv_core.v
│
├── tb/
│   ├── README.md
│   └── tb_riscv_core.v
│
├── programs/
│   └── README.md
│
├── waveforms/
│   ├── README.md
│   └── riscv_core.vcd
│
└── docs/
    ├── README.md
    ├── project_structure.png
    ├── riscv_core_code.png
    ├── simulation_results.png
    └── waveform_full_verification.png
    
# Simulation

The design can be compiled using Icarus Verilog by providing the RTL source files and testbench.

Example:
iverilog -g2012 -s tb_riscv_core -o riscv_sim \
rtl/pc.v \
rtl/instruction_memory.v \
rtl/register_file.v \
rtl/alu.v \
rtl/immediate_generator.v \
rtl/control_unit.v \
rtl/data_memory.v \
rtl/riscv_core.v \
tb/tb_riscv_core.v

# Run the simulation:

vvp riscv_sim
The testbench generates:
waveforms/riscv_core.vcd
The waveform can then be opened using GTKWave.

# Project Highlights

- Designed a modular 32-bit RISC-V processor core in Verilog HDL
- Implemented a selected RV32I instruction subset
- Developed separate RTL modules for datapath and control functionality
- Created a dedicated functional verification testbench
- Verified arithmetic, branch, and jump operations
- Generated and analyzed VCD simulation waveforms using GTKWave
- Documented simulation results and RTL implementation

# Future Improvements

Possible extensions to the processor include:
- Expanding the supported RV32I instruction set
- Adding additional load/store instructions
- Adding more branch instructions
- Improving instruction-memory organization
- Adding automated regression tests
- Performing synthesis and reporting area/timing results
- Developing a more comprehensive ISA-level verification environment

Author
M. Sanketh
B.Tech Electronics and Communication Engineering
Interests: RTL Design, Verilog HDL, Digital Design, RISC-V and VLSI
