# MIPS16 Pipeline Processor  


## **Introduction**  
This project implements a MIPS16 processor with a pipelined architecture. The primary objective is to enhance the performance of a single-cycle processor by introducing pipeline stages and registers. The changes aim to minimize the number of clock cycles required for operations while addressing hazards inherent in pipelined processors.

---

## **Key Modifications to the Single-Cycle Processor**  
1. **Pipeline Registers:**  
   - Four new registers were added to store intermediate results between the five stages of the pipeline.  
   - These registers improve performance by allowing parallel execution of instructions across different stages.  

2. **Clock Edge Adjustment:**  
   - The clock edge check in the **Instruction Decode (ID)** stage was modified to the falling edge to avoid structural hazards.  

3. **Instruction Fetch Adjustments:**  
   - The assembly code was modified in the **Instruction Fetch (IF)** stage to reduce control and data hazards by strategically inserting **NoOps**.  

---

## **Pipeline Registers**  

The pipeline registers introduced are:  
- **IF/ID:** Holds instruction and PC (Program Counter) after the fetch stage.  
- **ID/EX:** Contains decoded instruction fields such as source and destination registers, and control signals for the execute stage.  
- **EX/MEM:** Holds the results from the execute stage, which are used in the memory stage.  
- **MEM/WB:** Contains data to be written back to the register file.  

---

## **Original Program**  
The original program is a loop-based algorithm that processes a sequence of numbers in memory. Below is the initial assembly code:  

```asm
0:  ADD  $1, $0, $0       # i = 0, loop counter  
1:  ADDI $4, $0, 5        # Save max iterations (5)  
2:  ADD  $2, $0, $0       # Initialize memory index  
3:  ADD  $5, $0, $0       # sum = 0  
4:  BEQ  $1, $4, 8        # Check if 5 iterations are done, jump out of loop  
5:  LW   $3, 0($2)        # Load current array element into $3  
6:  SLL  $3, $3, 2        # Shift $3 left by 2 (multiply by 4)  
7:  SW   $3, 0($2)        # Store updated value back into memory  
8:  ADD  $5, $5, $3       # Add current element to sum  
9:  ADDI $2, $2, 1        # Increment memory index  
10: ADDI $1, $1, 1        # Increment loop counter  
11: J    4                # Jump to loop start  
12: SW   $5, 10($2)       # Save sum to memory address 10  
