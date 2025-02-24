# 5-stage RISC-V softcore processor
## Datapath
![image](https://github.com/user-attachments/assets/b5a85df9-06a7-44b7-8997-de6fa9eff5ad)
## ALU
Module to perform all arithmetic operations. 
- Inputs: A, B, Select
- Ouputs: Output

## 2/23
- Workflow: text editor -> iverilog -> gtkwave
- When cloning, use ssh to avoid commit issues later
- Blocking vs non-blocking
    -Blocking: Used for sequential processing; denoted by '='
    -Non-Blocking: Used for non-sequential (parallel) processing; denoted by '<='
- Use case of all types of instructions
