// Behavioral model of MIPS, 3-stage pipeline for R-types and addi only

module reg_file (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);

  input [1:0] rr1,rr2,wr;
  input [15:0] wd;
  input regwrite,clock;
  output [15:0] rd1,rd2;
  wire [15:0] q0,q1,q2,q3;

  // registers

  register r0  (16'b0,c0,q0); //register $0
  register r1  (wd,c1,q1);
  register r2  (wd,c2,q2);
  register r3  (wd,c3,q3);

  // output port

  mux4x1_16 mux1 (16'b0,q1,q2,q3,rr1,rd1),
            mux2 (16'b0,q1,q2,q3,rr2,rd2);

  // input port

  decoder dec(wr[1],wr[0],w3,w2,w1,w0);

  and a (regwrite_and_clock,regwrite,clock);

  and a1 (c1,regwrite_and_clock,w1),
      a2 (c2,regwrite_and_clock,w2),
      a3 (c3,regwrite_and_clock,w3);

endmodule

module register(D, CLK, Q);
  input [15:0] D;
  input CLK;
  output [15:0] Q;

  D_flip_flop f1   (D[0], CLK, Q[0]);
  D_flip_flop f2   (D[1], CLK, Q[1]);
  D_flip_flop f3   (D[2], CLK, Q[2]);
  D_flip_flop f4   (D[3], CLK, Q[3]);
  D_flip_flop f5   (D[4], CLK, Q[4]);
  D_flip_flop f6   (D[5], CLK, Q[5]);
  D_flip_flop f7   (D[6], CLK, Q[6]);
  D_flip_flop f8   (D[7], CLK, Q[7]);
  D_flip_flop f9   (D[8], CLK, Q[8]);
  D_flip_flop f10  (D[9], CLK, Q[9]);
  D_flip_flop f11  (D[10],CLK, Q[10]);
  D_flip_flop f12  (D[11],CLK, Q[11]);
  D_flip_flop f13  (D[12],CLK, Q[12]);
  D_flip_flop f14  (D[13],CLK, Q[13]);
  D_flip_flop f15  (D[14],CLK, Q[14]);
  D_flip_flop f16  (D[15],CLK, Q[15]);
endmodule

module D_flip_flop(D,CLK,Q);
  input D,CLK; 
  output Q; 
  wire CLK1, Y;

  not  not1 (CLK1,CLK);
  D_latch D1(D,CLK, Y),
          D2(Y,CLK1,Q);
endmodule 

module D_latch(D,C,Q);
  input D,C; 
  output Q;
  wire x,y,D1,Q1;

  nand nand1 (x,D, C), 
       nand2 (y,D1,C), 
       nand3 (Q,x,Q1),
       nand4 (Q1,y,Q); 
  not  not1  (D1,D);
endmodule

module mux4x1_16(i0,i1,i2,i3,select,y);
  input [15:0] i0,i1,i2,i3;
  input [1:0] select;
  output [15:0] y;

  mux4x1 mux1 (i0[0], i1[0], i2[0], i3[0], select,y[0]);
  mux4x1 mux2 (i0[1], i1[1], i2[1], i3[1], select,y[1]);
  mux4x1 mux3 (i0[2], i1[2], i2[2], i3[2], select,y[2]);
  mux4x1 mux4 (i0[3], i1[3], i2[3], i3[3], select,y[3]);
  mux4x1 mux5 (i0[4], i1[4], i2[4], i3[4], select,y[4]);
  mux4x1 mux6 (i0[5], i1[5], i2[5], i3[5], select,y[5]);
  mux4x1 mux7 (i0[6], i1[6], i2[6], i3[6], select,y[6]);
  mux4x1 mux8 (i0[7], i1[7], i2[7], i3[7], select,y[7]);
  mux4x1 mux9 (i0[8], i1[8], i2[8], i3[8], select,y[8]);
  mux4x1 mux10(i0[9], i1[9], i2[9], i3[9], select,y[9]);
  mux4x1 mux11(i0[10],i1[10],i2[10],i3[10],select,y[10]);
  mux4x1 mux12(i0[11],i1[11],i2[11],i3[11],select,y[11]);
  mux4x1 mux13(i0[12],i1[12],i2[12],i3[12],select,y[12]);
  mux4x1 mux14(i0[13],i1[13],i2[13],i3[13],select,y[13]);
  mux4x1 mux15(i0[14],i1[14],i2[14],i3[14],select,y[14]);
  mux4x1 mux16(i0[15],i1[15],i2[15],i3[15],select,y[15]);
endmodule

module mux2x1_16(i0,i1,select,y);
  input [15:0] i0,i1,i2,i3;
  input select;
  output [15:0] y;

  mux2x1 mux1 (i0[0], i1[0], select,y[0]);
  mux2x1 mux2 (i0[1], i1[1], select,y[1]);
  mux2x1 mux3 (i0[2], i1[2], select,y[2]);
  mux2x1 mux4 (i0[3], i1[3], select,y[3]);
  mux2x1 mux5 (i0[4], i1[4], select,y[4]);
  mux2x1 mux6 (i0[5], i1[5], select,y[5]);
  mux2x1 mux7 (i0[6], i1[6], select,y[6]);
  mux2x1 mux8 (i0[7], i1[7], select,y[7]);
  mux2x1 mux9 (i0[8], i1[8], select,y[8]);
  mux2x1 mux10(i0[9], i1[9], select,y[9]);
  mux2x1 mux11(i0[10],i1[10], select,y[10]);
  mux2x1 mux12(i0[11],i1[11], select,y[11]);
  mux2x1 mux13(i0[12],i1[12], select,y[12]);
  mux2x1 mux14(i0[13],i1[13], select,y[13]);
  mux2x1 mux15(i0[14],i1[14], select,y[14]);
  mux2x1 mux16(i0[15],i1[15], select,y[15]);
endmodule

module mux2x1_2(i0,i1,select,y);
  input [1:0] i0,i1;
  input select;
  output [1:0] y;

  mux2x1 mux1 (i0[0], i1[0], select,y[0]);
  mux2x1 mux2 (i0[1], i1[1], select,y[1]);
endmodule

module decoder (S1,S0,D3,D2,D1,D0); 
  input S0,S1; 
  output D0,D1,D2,D3; 
 
  not n1 (notS0,S0),
      n2 (notS1,S1);

  and a0 (D0,notS1,notS0), 
      a1 (D1,notS1,   S0), 
      a2 (D2,   S1,notS0), 
      a3 (D3,   S1,   S0); 
endmodule

module ALU (op,a,b,result,zero);
  input [15:0] a;
  input [15:0] b;
  input [2:0] op;
  output [15:0] result;
  output zero;
  wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16;

  ALU1   alu0  (a[0], b[0], op[2],op[1:0],set,op[2],c1, result[0]);
  ALU1   alu1  (a[1], b[1], op[2],op[1:0],0,  c1,   c2, result[1]);
  ALU1   alu2  (a[2], b[2], op[2],op[1:0],0,  c2,   c3, result[2]);
  ALU1   alu3  (a[3], b[3], op[2],op[1:0],0,  c3,   c4, result[3]);
  ALU1   alu4  (a[4], b[4], op[2],op[1:0],0,  c4,   c5, result[4]);
  ALU1   alu5  (a[5], b[5], op[2],op[1:0],0,  c5,   c6, result[5]);
  ALU1   alu6  (a[6], b[6], op[2],op[1:0],0,  c6,   c7, result[6]);
  ALU1   alu7  (a[7], b[7], op[2],op[1:0],0,  c7,   c8, result[7]);
  ALU1   alu8  (a[8], b[8], op[2],op[1:0],0,  c8,   c9, result[8]);
  ALU1   alu9  (a[9], b[9], op[2],op[1:0],0,  c9,   c10,result[9]);
  ALU1   alu10 (a[10],b[10],op[2],op[1:0],0,  c10,  c11,result[10]);
  ALU1   alu11 (a[11],b[11],op[2],op[1:0],0,  c11,  c12,result[11]);
  ALU1   alu12 (a[12],b[12],op[2],op[1:0],0,  c12,  c13,result[12]);
  ALU1   alu13 (a[13],b[13],op[2],op[1:0],0,  c13,  c14,result[13]);
  ALU1   alu14 (a[14],b[14],op[2],op[1:0],0,  c14,  c15,result[14]);
  ALUmsb alu15 (a[15],b[15],op[2],op[1:0],0,  c15,  c16,result[15],set);
  
  or or1(or01, result[0], result[1]);
  or or2(or23, result[2], result[3]);

  nor nor1(zero,or01,or23);

endmodule


// 1-bit ALU for bits 0-14

module ALU1 (a,b,binvert,op,less,carryin,carryout,result);
  input a,b,less,carryin,binvert;
  input [1:0] op;
  output carryout,result;
  wire sum, a_and_b, a_or_b, b_inv;

  not not1(b_inv, b);
  mux2x1 mux1(b,b_inv,binvert,b1);
  and and1(a_and_b, a, b);
  or or1(a_or_b, a, b);
  fulladder adder1(sum,carryout,a,b1,carryin);
  mux4x1 mux2(a_and_b,a_or_b,sum,less,op[1:0],result); 

endmodule


// 1-bit ALU for the most significant bit

module ALUmsb (a,b,binvert,op,less,carryin,carryout,result,sum);
  input a,b,less,carryin,binvert;
  input [1:0] op;
  output carryout,result,sum;
  wire sum, a_and_b, a_or_b, b_inv;

  not not1(b_inv, b);
  mux2x1 mux1(b,b_inv,binvert,b1);
  and and1(a_and_b, a, b);
  or or1(a_or_b, a, b);
  fulladder adder1(sum,carryout,a,b1,carryin);
  mux4x1 mux2(a_and_b,a_or_b,sum,less,op[1:0],result); 

endmodule


module halfadder (S,C,x,y); 
  input x,y; 
  output S,C; 

  xor (S,x,y); 
  and (C,x,y); 
endmodule 


module fulladder (S,C,x,y,z); 
  input x,y,z; 
  output S,C; 
  wire S1,D1,D2;

  halfadder HA1 (S1,D1,x,y), HA2 (S,D2,S1,z); 
  or g1(C,D2,D1); 
endmodule


module mux2x1(A,B,select,OUT); 
  input A,B,select; 
  output OUT;

  not not1(i0, select);
  and and1(i1, A, i0);
  and and2(i2, B, select);
  or or1(OUT, i1, i2);
endmodule 

module mux4x1(i0,i1,i2,i3,select,y); 
  input i0,i1,i2,i3; 
  input [1:0] select; 
  output y;
  
  mux2x1 mux1(i0, i1, select[0], m1);
  mux2x1 mux2(i2, i3, select[0], m2);
  mux2x1 mux3(m1, m2, select[1], y);
endmodule


module MainControl (Op,Control); 

  input [3:0] Op;
  output reg [9:0] Control;

  always @(Op) case (Op)
    4'b0000: Control <= 10'b1001000010; // ADD
    4'b0001: Control <= 10'b1001000110; // SUB
    4'b0010: Control <= 10'b1001000000; // AND
    4'b0011: Control <= 10'b1001000001; // OR
    4'b0111: Control <= 10'b1001000111; // SLT
    4'b0101: Control <= 10'b0111000010; // LW  <-
    4'b0110: Control <= 10'b0100100010; // SW  <-
    4'b1000: Control <= 10'b0000001110; // BEQ <-
    4'b1001: Control <= 10'b0000010110; // BNE <-
    4'b0100: Control <= 10'b0101000010; // ADDI  
  endcase

endmodule


// module BranchControl (BranchOp,Zero,BranchOut);

//   input [1:0] BranchOp;
//   input Zero;
//   output BranchOut;
//   wire ZeroInvert,i0,i1;

//   not not1(ZeroInvert,Zero);
//   and and1(i0,BranchOp[0],Zero);
//   and and2(i1,BranchOp[1],ZeroInvert);
//   or or1(BranchOut,i0,i1);

// endmodule

module CPU (clock,PC,IFID_IR,IDEX_IR,WD);

  input clock;
  output [15:0] PC,IFID_IR,IDEX_IR,WD;

  initial begin 
    // Program: remove nop's and check the result
    IMemory[0]  = 16'b0100000100001111; // addi $t1, $0, 15   # $t1 = 15
    IMemory[1]  = 16'b0100001000000111; // addi $t2, $0, 7    # $t2 = 7
    IMemory[2]  = 16'b0000000000000000; // nop
    IMemory[3]  = 16'b0010011011000000; // and  $t3, $t1, $t2 # $t3 = 7
    IMemory[4]  = 16'b0000000000000000; // nop
    IMemory[5]  = 16'b0001011110000000; // sub  $t2, $t1, $t3 # $t2 = 8
    IMemory[6]  = 16'b0000000000000000; // nop
    IMemory[7]  = 16'b0011101110000000; // or   $t2, $t2, $t3 # $t2 = 15
    IMemory[8]  = 16'b0000000000000000; // nop
    IMemory[9]  = 16'b0000101111000000; // add  $t3, $t2, $t3 # $t3 = 22
    IMemory[10] = 16'b0000000000000000; // nop
    IMemory[11] = 16'b0111111001000000; // slt  $t1, $t3, $t2 # $t1 = 0
    IMemory[12] = 16'b0111101101000000; // slt  $t1, $t2, $t3 # $t1 = 1

    // IMemory[0]  = 32'h2009000f;  // addi $t1, $0,  15   ($t1=15)
    // IMemory[1]  = 32'h200a0007;  // addi $t2, $0,  7    ($t2= 7)
    // IMemory[2]  = 32'h00000000;  // nop
    // IMemory[3]  = 32'h012a5824;  // and  $t3, $t1, $t2  ($t3= 7)
    // IMemory[4]  = 32'h00000000;  // nop
    // IMemory[5]  = 32'h012b5022;  // sub  $t2, $t1, $t3  ($t2= 8)
    // IMemory[6]  = 32'h00000000;  // nop
    // IMemory[7]  = 32'h014b5025;  // or   $t2, $t2, $t3  ($t2=15)
    // IMemory[8]  = 32'h00000000;  // nop
    // IMemory[9]  = 32'h014b5820;  // add  $t3, $t2, $t3  ($t3=22)
    // IMemory[10] = 32'h00000000;  // nop
    // IMemory[11] = 32'h016a482a;  // slt  $t1, $t3, $t2  ($t1= 0)
    // IMemory[12] = 32'h014b482a;  // slt  $t1, $t2, $t3  ($t1= 1)
  end

  // Pipeline stages

  // IF 
  wire [15:0] PCplus2, NextPC;
  reg[15:0] PC, IMemory[0:1023], IFID_IR;
  ALU fetch (3'b010,PC,2,NextPC,Unused);

  // ID
  reg [15:0] IDEX_IR; // For monitoring the pipeline
  wire [9:0] Control; // Needs to be checked for compliance with 16-bit
  reg IDEX_RegWrite, IDEX_ALUSrc, IDEX_RegDst, IDEX_MemtoReg, IDEX_MemWrite;
  reg [1:0] IDEX_Branch;
  reg [2:0]  IDEX_ALUOp; // Needs to be checked for compliance with 16-bit
  wire [15:0] RD1,RD2,SignExtend, WD;
  reg [15:0] IDEX_RD1,IDEX_RD2,IDEX_SignExt;
  reg [1:0]  IDEX_rt,IDEX_rd; // Needs to be checked for compliance with 16-bit
  reg_file rf (IFID_IR[11:10],IFID_IR[9:8],WR,WD,IDEX_RegWrite,RD1,RD2,clock);
  MainControl MainCtr (IFID_IR[15:12],Control); 
  assign SignExtend = {{8{IFID_IR[7]}},IFID_IR[7:0]}; 
  
  // EXE
  wire [15:0] B,ALUOut;
  // wire [2:0] ALUctl;
  wire [1:0] WR;
  ALU ex (IDEX_ALUOp, IDEX_RD1, B, ALUOut, Zero);
  // ALUControl ALUCtrl(IDEX_ALUOp, IDEX_IR[5:0], ALUctl); // ALU control unit
  // assign B  = (IDEX_ALUSrc) ? IDEX_SignExt: IDEX_RD2;        // ALUSrc Mux 
  mux2x1_16 ALUSrcMux (IDEX_RD2, IDEX_SignExt, IDEX_ALUSrc, B);
  // assign WR = (IDEX_RegDst) ? IDEX_rd: IDEX_rt;              // RegDst Mux
  mux2x1_2 RegDstMux (IDEX_rt, IDEX_rd, IDEX_RegDst, WR);
  assign WD = ALUOut;

  initial begin
    PC = 0;
  end

  // Running the pipeline

  always @(negedge clock) begin 

    // Stage 1 - IF
    PC <= NextPC;
    IFID_IR <= IMemory[PC>>1];

    // Stage 2 - ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,
     IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,IDEX_ALUOp} <= Control;    
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[20:16]; // Needs to be converted to 16-bit
    IDEX_rd <= IFID_IR[15:11]; // Needs to be converted to 16-bit

  // Stage 3 - EX
  // No transfers needed here - on negedge WD is written into register WR

  end

endmodule


// Test module

module test ();

  reg clock;
  wire [15:0] PC,IFID_IR,IDEX_IR,WD;

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,WD);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time PC  IFID_IR  IDEX_IR  WD");
    $monitor ("%2d  %3d  %b     %b     %d", $time,PC,IFID_IR,IDEX_IR,WD);
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
