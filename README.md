# 5-Stage RISC-V Softcore Processor
## Workflow
- Install Icarus Verilog and GTKWave
- To complile SystemVerilog
```verilog
iverilog -g2012 -o [output file] [design file] [testbench file] [header file]
```
- To simulate SystemVerilog
```verilog
vvp [output file]
```
- To view waveforms
```verilog
gtkwave [vcd file]
```
## Datapath
![riscv-datapath](https://github.com/user-attachments/assets/b5a85df9-06a7-44b7-8997-de6fa9eff5ad)
## RV32I Instruction Types
![riscv-instructions](https://github.com/user-attachments/assets/aed43d6b-19bf-4b4e-9862-b42efd4b2c5e)
## ALU
Module to perform all arithmetic operations. 
- Inputs: [31:0] a, [31:0] b, [3:0] sel
- Ouputs: [31:0] out
## Immediate Generator
Module to extract and format all immediates for I,S,B,U, and J type instructions
- Inputs: [25:0] inst, [2:0] imm_sel
- Ouputs: [31:0] out

![riscv-immediate](https://github.com/user-attachments/assets/0b8ba84b-2b19-4ab7-9a12-8d53ac34be0c)
## Working Notes
- When cloning, use ssh to avoid commit issues later
- Blocking vs non-blocking
    - Blocking: Used for sequential processing; denoted by '='
    - Non-Blocking: Used for non-sequential (parallel) processing; denoted by '<='
- $signed() to show pos/neg numbers in console output
- Combinational logic: output is only dependent on inputs, works async/no clock
