// Behavioral model of MIPS - pipelined implementation

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

module CPU (clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  input clock;
  output [31:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;

  initial begin 
// Program: swap memory cells (if needed) and compute absolute value |5-7|=2
   IMemory[0]  = 32'h8c080000;  // lw $8, 0($0)
   IMemory[1]  = 32'h8c090004;  // lw $9, 4($0)
   IMemory[2]  = 32'h00000000;  // nop
   IMemory[3]  = 32'h00000000;  // nop
   IMemory[4]  = 32'h00000000;  // nop
   IMemory[5]  = 32'h0109502a;  // slt $10, $8, $9
   IMemory[6]  = 32'h00000000;  // nop
   IMemory[7]  = 32'h00000000;  // nop
   IMemory[8]  = 32'h00000000;  // nop
   IMemory[9]  = 32'h11400005;  // beq $10, $0, IMemory[15]  
   IMemory[10] = 32'h00000000;  // nop
   IMemory[11] = 32'h00000000;  // nop
   IMemory[12] = 32'h00000000;  // nop
   IMemory[13] = 32'hac080004;  // sw $8, 4($0)
   IMemory[14] = 32'hac090000;  // sw $9, 0($0)
   IMemory[15] = 32'h00000000;  // nop
   IMemory[16] = 32'h00000000;  // nop
   IMemory[17] = 32'h00000000;  // nop
   IMemory[18] = 32'h8c080000;  // lw $8, 0($0)
   IMemory[19] = 32'h8c090004;  // lw $9, 4($0)
   IMemory[20] = 32'h00000000;  // nop
   IMemory[21] = 32'h00000000;  // nop
   IMemory[22] = 32'h00000000;  // nop
   IMemory[23] = 32'h01095022;  // sub $10, $8, $9
// Data
   DMemory [0] = 32'h5; // switch the cells and see how the simulation output changes
   DMemory [1] = 32'h7; // (beq is taken if [0]=32'h7; [1]=32'h5, not taken otherwise)
  end

// Pipeline 

// IF 
   wire [31:0] PCplus4, NextPC;
   reg[31:0] PC, IMemory[0:1023], IFID_IR, IFID_PCplus4;
   alu fetch (3'b010,PC,4,PCplus4,Unused1);
   assign NextPC = (EXMEM_Branch && EXMEM_Zero) ? EXMEM_Target: PCplus4;

// ID
   wire [7:0] Control;
   reg IDEX_RegWrite,IDEX_MemtoReg,
       IDEX_Branch,  IDEX_MemWrite,
       IDEX_ALUSrc,  IDEX_RegDst;
   reg [1:0]  IDEX_ALUOp;
   wire [31:0] RD1,RD2,SignExtend, WD;
   reg [31:0] IDEX_PCplus4,IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEXE_IR;
   reg [31:0] IDEX_IR; // For monitoring the pipeline
   reg [4:0]  IDEX_rt,IDEX_rd;
   reg_file rf (IFID_IR[25:21],IFID_IR[20:16],MEMWB_rd,WD,MEMWB_RegWrite,RD1,RD2,clock);
   MainControl MainCtr (IFID_IR[31:26],Control); 
   assign SignExtend = {{16{IFID_IR[15]}},IFID_IR[15:0]}; 
  
// EXE
   reg EXMEM_RegWrite,EXMEM_MemtoReg,
       EXMEM_Branch,  EXMEM_MemWrite;
   wire [31:0] Target;
   reg EXMEM_Zero;
   reg [31:0] EXMEM_Target,EXMEM_ALUOut,EXMEM_RD2;
   reg [31:0] EXMEM_IR; // For monitoring the pipeline
   reg [4:0] EXMEM_rd;
   wire [31:0] B,ALUOut;
   wire [2:0] ALUctl;
   wire [4:0] WR;
   alu branch (3'b010,IDEX_SignExt<<2,IDEX_PCplus4,Target,Unused2);
   alu ex (ALUctl, IDEX_RD1, B, ALUOut, Zero);
   ALUControl ALUCtrl(IDEX_ALUOp, IDEX_SignExt[5:0], ALUctl); // ALU control unit
   assign B  = (IDEX_ALUSrc) ? IDEX_SignExt: IDEX_RD2;        // ALUSrc Mux 
   assign WR = (IDEX_RegDst) ? IDEX_rd: IDEX_rt;              // RegDst Mux

// MEM
   reg MEMWB_RegWrite,MEMWB_MemtoReg;
   reg [31:0] DMemory[0:1023],MEMWB_MemOut,MEMWB_ALUOut;
   reg [31:0] MEMWB_IR; // For monitoring the pipeline
   wire [31:0] MemOut;
   reg [4:0] MEMWB_rd;
   assign MemOut = DMemory[EXMEM_ALUOut>>2];
   always @(negedge clock) if (EXMEM_MemWrite) DMemory[EXMEM_ALUOut>>2] <= EXMEM_RD2;
  
// WB
   assign WD = (MEMWB_MemtoReg) ? MEMWB_MemOut: MEMWB_ALUOut; // MemtoReg Mux


   initial begin
    PC = 0;
// Initialize pipeline registers
    IDEX_RegWrite=0;IDEX_MemtoReg=0;IDEX_Branch=0;IDEX_MemWrite=0;IDEX_ALUSrc=0;IDEX_RegDst=0;IDEX_ALUOp=0;
    IFID_IR=0;
    EXMEM_RegWrite=0;EXMEM_MemtoReg=0;EXMEM_Branch=0;EXMEM_MemWrite=0;
    EXMEM_Target=0;
    MEMWB_RegWrite=0;MEMWB_MemtoReg=0;
   end

// Running the pipeline

   always @(negedge clock) begin 

// IF
    PC <= NextPC;
    IFID_PCplus4 <= PCplus4;
    IFID_IR <= IMemory[PC>>2];

// ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,IDEX_ALUOp} <= Control;   
    IDEX_PCplus4 <= IFID_PCplus4;
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[20:16];
    IDEX_rd <= IFID_IR[15:11];

// EXE
    EXMEM_IR <= IDEX_IR; // For monitoring the pipeline
    EXMEM_RegWrite <= IDEX_RegWrite;
    EXMEM_MemtoReg <= IDEX_MemtoReg;
    EXMEM_Branch   <= IDEX_Branch;
    EXMEM_MemWrite <= IDEX_MemWrite;
    EXMEM_Target <= Target;
    EXMEM_Zero <= Zero;
    EXMEM_ALUOut <= ALUOut;
    EXMEM_RD2 <= IDEX_RD2;
    EXMEM_rd <= WR;

// MEM
    MEMWB_IR <= EXMEM_IR; // For monitoring the pipeline
    MEMWB_RegWrite <= EXMEM_RegWrite;
    MEMWB_MemtoReg <= EXMEM_MemtoReg;
    MEMWB_MemOut <= MemOut;
    MEMWB_ALUOut <= EXMEM_ALUOut;
    MEMWB_rd <= EXMEM_rd;

// WB
// Register write happens on neg edge of the clock (if MEMWB_RegWrite is asserted)

  end

endmodule


// Test module

module test ();

  reg clock;
  wire [31:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD");
    $monitor ("%2d  %3d  %h %h %h %h %h", $time,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
    clock = 1;
    #56 $finish;
  end

endmodule


/* Compiling and simulation

C:\Markov\CCSU Stuff\Courses\Spring-10\CS385\HDL>iverilog mips-pipe.vl

C:\Markov\CCSU Stuff\Courses\Spring-10\CS385\HDL>vvp a.out

time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD
 0    0  00000000 xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
 1    4  8c080000 00000000 xxxxxxxx xxxxxxxx xxxxxxxx
 3    8  8c090004 8c080000 00000000 xxxxxxxx xxxxxxxx
 5   12  00000000 8c090004 8c080000 00000000 00000000
 7   16  00000000 00000000 8c090004 8c080000 00000005
 9   20  00000000 00000000 00000000 8c090004 00000007
11   24  0109502a 00000000 00000000 00000000 00000000
13   28  00000000 0109502a 00000000 00000000 00000000
15   32  00000000 00000000 0109502a 00000000 00000000
17   36  00000000 00000000 00000000 0109502a 00000001
19   40  11400005 00000000 00000000 00000000 00000000
21   44  00000000 11400005 00000000 00000000 00000000
23   48  00000000 00000000 11400005 00000000 00000000
25   52  00000000 00000000 00000000 11400005 00000001
27   56  ac080004 00000000 00000000 00000000 00000000
29   60  ac090000 ac080004 00000000 00000000 00000000
31   64  00000000 ac090000 ac080004 00000000 00000000
33   68  00000000 00000000 ac090000 ac080004 00000004
35   72  00000000 00000000 00000000 ac090000 00000000
37   76  8c0b0000 00000000 00000000 00000000 00000000
39   80  8c0c0004 8c0b0000 00000000 00000000 00000000
41   84  00000000 8c0c0004 8c0b0000 00000000 00000000
43   88  00000000 00000000 8c0c0004 8c0b0000 00000007
45   92  00000000 00000000 00000000 8c0c0004 00000005
47   96  016c5822 00000000 00000000 00000000 00000000
49  100  xxxxxxxx 016c5822 00000000 00000000 00000000
51  104  xxxxxxxx xxxxxxxx 016c5822 00000000 00000000
53  108  xxxxxxxx xxxxxxxx xxxxxxxx 016c5822 00000002
55  112  xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx 0000000X

*/
