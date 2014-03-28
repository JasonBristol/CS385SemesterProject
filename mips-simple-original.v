// Behavioral model of MIPS - single cycle implementation

module reg_file (RR1,RR2,WR,WD,RegWrite,RD1,RD2,clock);

  input [4:0] RR1,RR2,WR;
  input [31:0] WD;
  input RegWrite,clock;
  output [31:0] RD1,RD2;

  reg [31:0] Regs[0:31];

  assign RD1 = Regs[RR1];
  assign RD2 = Regs[RR2];

  initial Regs[0] = 0;

  always @(negedge clock)
    if (RegWrite==1 & WR!=0) 
	Regs[WR] <= WD;

endmodule

module alu (ALUctl,A,B,ALUOut,Zero);

  input [2:0] ALUctl;
  input [31:0] A,B;
  output reg [31:0] ALUOut;
  output Zero;

  assign Zero = (ALUOut==0); // Zero is true if ALUOut is 0
  always @(ALUctl, A, B)     // reevaluate if these change
    case (ALUctl)
      3'b000: ALUOut <= A & B;
      3'b001: ALUOut <= A | B;
      3'b010: ALUOut <= A + B;
      3'b110: ALUOut <= A - B;
      3'b111: ALUOut <= A < B ? 1:0;
     default: ALUOut <= 0; //default to 0, should not happen;
   endcase

endmodule

module MainControl (Op,Control); 

  input [5:0] Op;
  output reg [7:0] Control;

  always @(Op) case (Op)
    6'b000000: Control <= 8'b10010010; // Rtype
    6'b100011: Control <= 8'b01110000; // LW    
    6'b101011: Control <= 8'b01001000; // SW    
    6'b000100: Control <= 8'b00000101; // BEQ    
  endcase

endmodule

module ALUControl (ALUOp,FuncCode,ALUCtl); 
  input [1:0] ALUOp;
  input [5:0] FuncCode;
  output reg [2:0] ALUCtl;

  always @(ALUOp,FuncCode) case (ALUOp)
    2'b00: ALUCtl <= 3'b010; // add
    2'b01: ALUCtl <= 3'b110; // subtract
    2'b10: case (FuncCode)
	     32: ALUCtl <= 3'b010; // add
	     34: ALUCtl <= 3'b110; // subtract
	     36: ALUCtl <= 3'b000; // and
	     37: ALUCtl <= 3'b001; // or
	     42: ALUCtl <= 3'b111; // slt
	default: ALUCtl <= 15; 
    endcase
  endcase
endmodule

module CPU (clock,WD,IR);

  input clock;
  output [31:0] WD,IR;
  reg[31:0] PC, IMemory[0:1023], DMemory[0:1023];
  wire [31:0] IR,SignExtend,NextPC,RD2,A,B,ALUOut,PCplus4,Target;
  wire [4:0] WR;
  wire [5:0] op,func;
  wire [2:0] ALUctl;
  wire [1:0] ALUOp;

  initial begin 
  // Program: swap memory cells and compute absolute value
    IMemory[0] = 32'h8c080000;  // lw $8, 0($0)
    IMemory[1] = 32'h8c090004;  // lw $9, 4($0)
    IMemory[2] = 32'h0109502a;  // slt $10, $8, $9
    IMemory[3] = 32'h11400002;  // beq $10, $0, 8
    IMemory[4] = 32'hac080004;  // sw $8, 4($0)
    IMemory[5] = 32'hac090000;  // sw $9, 0($0)
    IMemory[6] = 32'h8c0b0000;  // lw $11, 0($0)
    IMemory[7] = 32'h8c0c0004;  // lw $12, 4($0)
    IMemory[8] = 32'h016c5822;  // sub $11, $11, $12

  // Data
    DMemory [0] = 32'h5; // switch the cells and see how the simulation output changes
    DMemory [1] = 32'h7;
  end

  initial PC = 0;

  assign IR = IMemory[PC>>2];
  assign SignExtend = {{16{IR[15]}},IR[15:0]}; // sign extension

  reg_file rf (IR[25:21],IR[20:16],WR,WD,RegWrite,A,RD2,clock);

  alu fetch (3'b010,PC,4,PCplus4,Unused1);
  alu ex (ALUctl, A, B, ALUOut, Zero);
  alu branch (3'b010,SignExtend<<2,PCplus4,Target,Unused2);

  MainControl MainCtr (IR[31:26],{RegDst,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,ALUOp}); 
  ALUControl ALUCtrl(ALUOp, IR[5:0], ALUctl); // ALU control unit
  
  assign WR = (RegDst) ? IR[15:11]: IR[20:16]; // RegDst Mux
  assign WD = (MemtoReg) ? DMemory[ALUOut>>2]: ALUOut; // MemtoReg Mux
  assign B  = (ALUSrc) ? SignExtend: RD2; // ALUSrc Mux 
  assign NextPC = (Branch && Zero) ? Target: PCplus4; // Branch Mux

  always @(negedge clock) begin 
    PC <= NextPC;
    if (MemWrite) DMemory[ALUOut>>2] <= RD2;
  end

endmodule


// Test module

module test ();

  reg clock;
  wire [31:0] WD,IR;

  CPU test_cpu(clock,WD,IR);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time clock IR       WD");
    $monitor ("%2d   %b     %h %h", $time,clock,IR,WD);
    clock = 1;
    #18 $finish;
  end

endmodule


/* Compiling and simulation

C:\CS385\HDL>iverilog mips-simple.vl

C:\CS385\HDL>vvp a.out

time clock IR       WD
 0   0     8c080000 00000005
 1   1     8c090004 00000007
 2   0     8c090004 00000007
 3   1     0109502a 00000001
 4   0     0109502a 00000001
 5   1     11400002 00000001
 6   0     11400002 00000001
 7   1     ac080004 00000004
 8   0     ac080004 00000004
 9   1     ac090000 00000000
10   0     ac090000 00000000
11   1     8c0b0000 00000007
12   0     8c0b0000 00000007
13   1     8c0c0004 00000005
14   0     8c0c0004 00000005
15   1     016c5822 00000002
16   0     016c5822 00000002
17   1     xxxxxxxx 0000000X

*/
