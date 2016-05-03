# SIC-XE
Two Pass Assembler for SIC/XE
The project is implemented using Lex and Yacc.
The in.txt file contains a sample SIC/XE program.
Out.txt contains the intermediate file which contains the output of the first pass of the assembler.
Obj.txt contains the object code listing which is the final output of the second pass.
Datastructures.h contains all the required data structures required for the working of the assembler.
Data.h file is dynamically written during the execution of the first pass, it contains data required to be transferred to second pass because both the passes are executed in separate processes.
Pass1_lex.l along with the yacc file test_yacc.y forms the first pass of the assembler.
Pass2_lex.l forms the second pass.
