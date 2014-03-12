// Behavioral model of MIPS, 3-stage pipeline for R-types and addi only

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
	     34: ALUCtl <= 3'b110; // subtract
	     36: ALUCtl <= 3'b000; // and
	     37: ALUCtl <= 3'b001; // or
	     42: ALUCtl <= 3'b111; // slt
	default: ALUCtl <= 15; 
    endcase
  endcase
endmodule

module CPU (clock,PC,IFID_IR,IDEX_IR,WD);

  input clock;
  output [31:0] PC,IFID_IR,IDEX_IR,WD;

  initial begin 
// Program: remove nop's and check the result
    IMemory[0]  = 32'h2009000f;  // addi $t1, $0,  15   ($t1=15)
    IMemory[1]  = 32'h200a0007;  // addi $t2, $0,  7    ($t2= 7)
    IMemory[2]  = 32'h00000000;  // nop
    IMemory[3]  = 32'h012a5824;  // and  $t3, $t1, $t2  ($t3= 7)
    IMemory[4]  = 32'h00000000;  // nop
    IMemory[5]  = 32'h012b5022;  // sub  $t2, $t1, $t3  ($t2= 8)
    IMemory[6]  = 32'h00000000;  // nop
    IMemory[7]  = 32'h014b5025;  // or   $t2, $t2, $t3  ($t2=15)
    IMemory[8]  = 32'h00000000;  // nop
    IMemory[9]  = 32'h014b5820;  // add  $t3, $t2, $t3  ($t3=22)
    IMemory[10] = 32'h00000000;  // nop
    IMemory[11] = 32'h016a482a;  // slt  $t1, $t3, $t2  ($t1= 0)
    IMemory[12] = 32'h014b482a;  // slt  $t1, $t2, $t3  ($t1= 1)
  end

// Pipeline stages

// IF 
   wire [31:0] PCplus4, NextPC;
   reg[31:0] PC, IMemory[0:1023], IFID_IR, IFID_PCplus4;
   alu fetch (3'b010,PC,4,NextPC,Unused);

// ID
   reg [31:0] IDEX_IR; // For monitoring the pipeline
   wire [7:0] Control;
   reg IDEX_RegWrite,IDEX_MemtoReg,
       IDEX_Branch,  IDEX_MemWrite,
       IDEX_ALUSrc,  IDEX_RegDst;
   reg [1:0]  IDEX_ALUOp;
   wire [31:0] RD1,RD2,SignExtend, WD;
   reg [31:0] IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEXE_IR;
   reg [4:0]  IDEX_rt,IDEX_rd;
   reg_file rf (IFID_IR[25:21],IFID_IR[20:16],WR,WD,IDEX_RegWrite,RD1,RD2,clock);
   MainControl MainCtr (IFID_IR[31:26],Control); 
   assign SignExtend = {{16{IFID_IR[15]}},IFID_IR[15:0]}; 
  
// EXE
   wire [31:0] B,ALUOut;
   wire [2:0] ALUctl;
   wire [4:0] WR;
   alu ex (ALUctl, IDEX_RD1, B, ALUOut, Zero);
   ALUControl ALUCtrl(IDEX_ALUOp, IDEX_IR[5:0], ALUctl); // ALU control unit
   assign B  = (IDEX_ALUSrc) ? IDEX_SignExt: IDEX_RD2;        // ALUSrc Mux 
   assign WR = (IDEX_RegDst) ? IDEX_rd: IDEX_rt;              // RegDst Mux
   assign WD = ALUOut;

   initial begin
    PC = 0;
   end

// Running the pipeline

   always @(negedge clock) begin 

// Stage 1 - IF
    PC <= NextPC;
    IFID_IR <= IMemory[PC>>2];

// Stage 2 - ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,
     IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,IDEX_ALUOp} <= Control;    
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[20:16];
    IDEX_rd <= IFID_IR[15:11];

// Stage 3 - EX
// No transfers needed here - on negedge WD is written into register WR

  end

endmodule


// Test module

module test ();

  reg clock;
  wire [31:0] PC,IFID_IR,IDEX_IR,WD;

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,WD);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time PC  IFID_IR  IDEX_IR  WD");
    $monitor ("%2d  %3d  %h %h %h", $time,PC,IFID_IR,IDEX_IR,WD);
    clock = 1;
    #29 $finish;
  end

endmodule


/* Compiling and simulation

>iverilog mips-pipe3.vl

>vvp a.out

time PC  IFID_IR  IDEX_IR  WD
 0    0  xxxxxxxx xxxxxxxx 00000000
 1    4  2009000f xxxxxxxx 00000000
 3    8  200a0007 2009000f 0000000f
 5   12  00000000 200a0007 00000007
 7   16  012a5824 00000000 00000000
 9   20  00000000 012a5824 00000007
11   24  012b5022 00000000 00000000
13   28  00000000 012b5022 00000008
15   32  014b5025 00000000 00000000
17   36  00000000 014b5025 0000000f
19   40  014b5820 00000000 00000000
21   44  00000000 014b5820 00000016
23   48  016a482a 00000000 00000000
25   52  014b482a 016a482a 00000000
27   56  xxxxxxxx 014b482a 00000001
29   60  xxxxxxxx xxxxxxxx 0000000X
*/
