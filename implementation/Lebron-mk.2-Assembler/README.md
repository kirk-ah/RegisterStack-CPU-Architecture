Assembler
---------------------------------
This directory contains the code to convery Lebron-mk.2 Register Stack assembly language into machine code.

How to use
---

-----

This assembler was written in Java, and translates assembly into machine code via reading from an assembly file and writing to a machine code file.
Following steps to use.

  * Open up eclipse, and import this project into the workspace.
  * Copy and paste, or write from scratch, the assembly code for a desired program.
  * Run Main.java, let it complete. The corresponding machine code is now in the machineCode.txt file.
  * In the Lebron-mk.2 Quartus project, select the machineCode.txt file as the text to put into the text segment of memory.
  * Let the datapath run the program.

-----
