// Behavioral model of MIPS - single cycle implementation, R-types and addi

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
    6'b100011: Control <= 8'b01110000; // LW  (Not implemented)
    6'b101011: Control <= 8'b01001000; // SW  (Not implemented)
    6'b000100: Control <= 8'b00000101; // BEQ (Not implemented)
    6'b001000: Control <= 8'b01010000; // ADDI
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
	     34: ALUCtl <= 3'b110; // sub
	     36: ALUCtl <= 3'b000; // and
	     37: ALUCtl <= 3'b001; // or
	     42: ALUCtl <= 3'b111; // slt
	default: ALUCtl <= 15; 
    endcase
  endcase
endmodule

module CPU (clock,ALUOut,IR);

  input clock;
  output [31:0] ALUOut,IR;
  reg[31:0] PC;
  reg[31:0] IMemory[0:1023];
  wire [31:0] IR,NextPC,A,B,ALUOut,RD2,SignExtend;
  wire [2:0] ALUctl;
  wire [1:0] ALUOp;
  wire [4:0] WR; 

// Test Program:
  initial begin 
    IMemory[0] = 32'h2009000f;  // addi $t1, $0,  15   ($t1=15)
    IMemory[1] = 32'h200a0007;  // addi $t2, $0,  7    ($t2= 7)
    IMemory[2] = 32'h012a5824;  // and  $t3, $t1, $t2  ($t3= 7)
    IMemory[3] = 32'h012b5022;  // sub  $t2, $t1, $t3  ($t2= 8)
    IMemory[4] = 32'h014b5025;  // or   $t2, $t2, $t3  ($t2=15)
    IMemory[5] = 32'h016a482a;  // slt  $t1, $t3, $t2  ($t1= 1)
    IMemory[6] = 32'h014b482a;  // slt  $t1, $t2, $t3  ($t1= 0)
  end

  initial PC = 0;

  assign IR = IMemory[PC>>2];

  assign WR = (RegDst) ? IR[15:11]: IR[20:16]; // RegDst Mux

  assign B  = (ALUSrc) ? SignExtend: RD2; // ALUSrc Mux 

  assign SignExtend = {{16{IR[15]}},IR[15:0]}; // sign extension unit

  reg_file rf (IR[25:21],IR[20:16],WR,ALUOut,RegWrite,A,RD2,clock);

  alu fetch (3'b010,PC,4,NextPC,Unused);

  alu ex (ALUctl, A, B, ALUOut, Zero);

  MainControl MainCtr (IR[31:26],{RegDst,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,ALUOp}); 

  ALUControl ALUCtrl(ALUOp, IR[5:0], ALUctl); // ALU control unit

  always @(negedge clock) begin 
    PC <= NextPC;
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
    #12 $finish;
  end

endmodule


/* Compiling and simulation

C:\Markov\CCSU Stuff\Courses\Spring-11\CS385\HDL>iverilog mips-r-type+addi.vl

C:\Markov\CCSU Stuff\Courses\Spring-11\CS385\HDL>vvp a.out

time clock IR       WD
 0   1     2009000f 0000000f
 1   0     200a0007 00000007
 2   1     200a0007 00000007
 3   0     012a5824 00000007
 4   1     012a5824 00000007
 5   0     012b5022 00000008
 6   1     012b5022 00000008
 7   0     014b5025 0000000f
 8   1     014b5025 0000000f
 9   0     016a482a 00000001
10   1     016a482a 00000001
11   0     014b482a 00000000
12   1     014b482a 00000000

*/
