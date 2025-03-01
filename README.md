# 5-stage RISC-V softcore processor
## Datapath
![image](https://github.com/user-attachments/assets/b5a85df9-06a7-44b7-8997-de6fa9eff5ad)
## Workflow
- Install Icarus Verilog and GTKWave
- To complile SystemVerilog
```verilog
iverilog -g2012 -o [output file] [design file] [testbench file] [header file]
```
## ALU
Module to perform all arithmetic operations. 
- Inputs: [31:0] a, [31:0] b, [3:0] sel
- Ouputs: [31:0] out
## Immediate Generator
Module to extract and format all immediates for I,S,B,U, and J type instructions
- Inputs: [25:0] inst, [2:0] imm_sel
- Ouputs: [31:0] out
## 2/23
- Workflow: text editor -> iverilog -> gtkwave
- When cloning, use ssh to avoid commit issues later
- Blocking vs non-blocking
    - Blocking: Used for sequential processing; denoted by '='
    - Non-Blocking: Used for non-sequential (parallel) processing; denoted by '<='
- Use case of all types of instructions
## 2/25
- use -g2012 flag for system verilog support
## 2/26
- $signed() to show pos/neg numbers in console output
- combinational logic: output is only dependent on inputs, works async/no clock
