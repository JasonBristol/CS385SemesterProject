// Behavioral model of MIPS - pipelined implementation

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
  output reg [10:0] Control;

  always @(Op) case (Op)
    //IDEX_RegDst,IDEX_ALUSrc[1:0],IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch[1:0],IDEX_ALUOp[2:0] 
    4'b0000: Control <= 11'b10001000010; // ADD
    4'b0001: Control <= 11'b10001000110; // SUB
    4'b0010: Control <= 11'b10001000000; // AND
    4'b0011: Control <= 11'b10001000001; // OR
    4'b0111: Control <= 11'b10001000111; // SLT
    4'b0101: Control <= 11'b00111000010; // LW
    4'b0110: Control <= 11'b00100100010; // SW
    4'b1000: Control <= 11'b00000001110; // BEQ
    4'b1001: Control <= 11'b00000010110; // BNE
    4'b0100: Control <= 11'b00101000010; // ADDI  
    4'b1111: Control <= 11'b01001000001; // LUI  
    
  endcase

endmodule

module BranchControl (BranchOp,Zero,BranchOut);

  input [1:0] BranchOp;
  input Zero;
  output BranchOut;
  wire ZeroInvert,i0,i1;

  not not1(ZeroInvert,Zero);
  and and1(i0,BranchOp[0],Zero);
  and and2(i1,BranchOp[1],ZeroInvert);
  or or1(BranchOut,i0,i1);

endmodule

module ALUSrcControl (ALUSRC, RD2, SignExt, ShiftToUpper, ALUSRCOP);
  
  input [15:0] RD2, SignExt, ShiftToUpper;
  input [1:0] ALUSRCOP;
  output [15:0] ALUSRC;
  wire w1;
  wire wa1_0,wa1_1,wa1_2,wa1_3,wa1_4,wa1_5,wa1_6,wa1_7,wa1_8,wa1_9,wa1_10,wa1_11,wa1_12,wa1_13,wa1_14,wa1_15; 
  wire wa2_0,wa2_1,wa2_2,wa2_3,wa2_4,wa2_5,wa2_6,wa2_7,wa2_8,wa2_9,wa2_10,wa2_11,wa2_12,wa2_13,wa2_14,wa2_15;
  wire wa3_0,wa3_1,wa3_2,wa3_3,wa3_4,wa3_5,wa3_6,wa3_7,wa3_8,wa3_9,wa3_10,wa3_11,wa3_12,wa3_13,wa3_14,wa3_15;
  
  nor nor1(w1, ALUSRCOP[0], ALUSRCOP[1]);
  
  and and1_0 (wa1_0,  w1, RD2[0]);    and and1_1 (wa1_1,  w1, RD2[1]);
  and and1_2 (wa1_2,  w1, RD2[2]);    and and1_3 (wa1_3,  w1, RD2[3]); 
  and and1_4 (wa1_4,  w1, RD2[4]);    and and1_5 (wa1_5,  w1, RD2[5]);
  and and1_6 (wa1_6,  w1, RD2[6]);    and and1_7 (wa1_7,  w1, RD2[7]);  
  and and1_8 (wa1_8,  w1, RD2[8]);    and and1_9 (wa1_9,  w1, RD2[9]);
  and and1_10(wa1_10, w1, RD2[10]);   and and1_11(wa1_11, w1, RD2[11]);
  and and1_12(wa1_12, w1, RD2[12]);   and and1_13(wa1_13, w1, RD2[13]);
  and and1_14(wa1_14, w1, RD2[14]);   and and1_15(wa1_15, w1, RD2[15]);

  and and2_0 (wa2_0,  ALUSRCOP[0], SignExt[0]);  and and2_1 (wa2_1,  ALUSRCOP[0], SignExt[1]);
  and and2_2 (wa2_2,  ALUSRCOP[0], SignExt[2]);  and and2_3 (wa2_3,  ALUSRCOP[0], SignExt[3]);
  and and2_4 (wa2_4,  ALUSRCOP[0], SignExt[4]);  and and2_5 (wa2_5,  ALUSRCOP[0], SignExt[5]);
  and and2_6 (wa2_6,  ALUSRCOP[0], SignExt[6]);  and and2_7 (wa2_7,  ALUSRCOP[0], SignExt[7]);
  and and2_8 (wa2_8,  ALUSRCOP[0], SignExt[8]);  and and2_9 (wa2_9,  ALUSRCOP[0], SignExt[9]); 
  and and2_10(wa2_10, ALUSRCOP[0], SignExt[10]); and and2_11(wa2_11, ALUSRCOP[0], SignExt[11]);
  and and2_12(wa2_12, ALUSRCOP[0], SignExt[12]); and and2_13(wa2_13, ALUSRCOP[0], SignExt[13]);
  and and2_14(wa2_14, ALUSRCOP[0], SignExt[14]); and and2_15(wa2_15, ALUSRCOP[0], SignExt[15]);

  and and3_0 (wa3_0,  ALUSRCOP[1], ShiftToUpper[0]);  and and3_1 (wa3_1,  ALUSRCOP[1], ShiftToUpper[1]); 
  and and3_2 (wa3_2,  ALUSRCOP[1], ShiftToUpper[2]);  and and3_3 (wa3_3,  ALUSRCOP[1], ShiftToUpper[3]); 
  and and3_4 (wa3_4,  ALUSRCOP[1], ShiftToUpper[4]);  and and3_5 (wa3_5,  ALUSRCOP[1], ShiftToUpper[5]);
  and and3_6 (wa3_6,  ALUSRCOP[1], ShiftToUpper[6]);  and and3_7 (wa3_7,  ALUSRCOP[1], ShiftToUpper[7]);
  and and3_8 (wa3_8,  ALUSRCOP[1], ShiftToUpper[8]);  and and3_9 (wa3_9,  ALUSRCOP[1], ShiftToUpper[9]);
  and and3_10(wa3_10, ALUSRCOP[1], ShiftToUpper[10]); and and3_11(wa3_11, ALUSRCOP[1], ShiftToUpper[11]);
  and and3_12(wa3_12, ALUSRCOP[1], ShiftToUpper[12]); and and3_13(wa3_13, ALUSRCOP[1], ShiftToUpper[13]);
  and and3_14(wa3_14, ALUSRCOP[1], ShiftToUpper[14]); and and3_15(wa3_15, ALUSRCOP[1], ShiftToUpper[15]);
  
  or(ALUSRC[0],  wa1_0,  wa2_0,  wa3_0);  or(ALUSRC[1],  wa1_1,  wa2_1,  wa3_1);
  or(ALUSRC[2],  wa1_2,  wa2_2,  wa3_2);  or(ALUSRC[3],  wa1_3,  wa2_3,  wa3_3);
  or(ALUSRC[4],  wa1_4,  wa2_4,  wa3_4);  or(ALUSRC[5],  wa1_5,  wa2_5,  wa3_5);
  or(ALUSRC[6],  wa1_6,  wa2_6,  wa3_6);  or(ALUSRC[7],  wa1_7,  wa2_7,  wa3_7);
  or(ALUSRC[8],  wa1_8,  wa2_8,  wa3_8);  or(ALUSRC[9],  wa1_9,  wa2_9,  wa3_9);
  or(ALUSRC[10], wa1_10, wa2_10, wa3_10); or(ALUSRC[11], wa1_11, wa2_11, wa3_11);
  or(ALUSRC[12], wa1_12, wa2_12, wa3_12); or(ALUSRC[13], wa1_13, wa2_13, wa3_13);
  or(ALUSRC[14], wa1_14, wa2_14, wa3_14); or(ALUSRC[15], wa1_15, wa2_15, wa3_15);
  
endmodule
  
module CPU (clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  input clock;
  output [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;

  initial begin 
// Program: swap memory cells (if needed) and compute absolute value |5-7|=2
   IMemory[0]  = 16'b1111000100000001;  // lui $1, 1         -- $1 = DMemory[0] - x
   IMemory[1]  = 16'b0000000000000000;  // nop
   IMemory[2]  = 16'b0000000000000000;  // nop
   IMemory[3]  = 16'b0101011000000000;  // lw  $2, 0($1)      -- $2 = DMemory[1] -y
   IMemory[4]  = 16'b0101011100000001;  // lw  $3, 1($1)
   IMemory[5]  = 16'b0000000000000000;  // nop
   IMemory[6]  = 16'b0000000000000000;  // nop
   IMemory[5]  = 16'b0000111001000000;  // add $3, $1, $2    -- Set $3 on less
   IMemory[6]  = 16'b0000000000000000;  // nop
   IMemory[7]  = 16'b0000000000000000;  // nop
// Data
   DMemory [0] = 16'd1; // switch the cells and see how the simulation output changes
   DMemory [1] = 16'd2; // (beq is taken if [0]=32'h7; [1]=32'h5, not taken otherwise)
   DMemory [2] = 16'd3;
   DMemory [3] = 16'd4;
   DMemory [4] = 16'd5;
   DMemory [5] = 16'd6;
   DMemory [6] = 16'd7;
   DMemory [7] = 16'd8;
   DMemory [511] = 16'd9;
   DMemory [512] = 16'd10;
   DMemory [513] = 16'd11;
   DMemory [514] = 16'd12;
   DMemory [515] = 16'd13;
   DMemory [516] = 16'd14;
   DMemory [517] = 16'd15;
   DMemory [518] = 16'd16;
  end

// Pipeline 

// IF 
   wire [15:0] PCplus2, NextPC;
   reg[15:0] PC, IMemory[0:1023], IFID_IR, IFID_PCplus2;
   ALU fetch (3'b010,PC,2,PCplus2,Unused1);
   assign NextPC = (EXMEM_Branch && EXMEM_Zero) ? EXMEM_Target: PCplus2; // Needs to be gate-level

// ID
   wire [10:0] Control;
   reg IDEX_RegWrite,IDEX_MemtoReg,IDEX_MemWrite,IDEX_RegDst;
   reg [1:0] IDEX_Branch, IDEX_ALUSrc;
   reg [2:0]  IDEX_ALUOp;
   wire [15:0] RD1,RD2,SignExtend, WD;
   reg [15:0] IDEX_PCplus2,IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEXE_IR;
   reg [15:0] IDEX_IR; // For monitoring the pipeline
   reg [1:0]  IDEX_rt,IDEX_rd;
   reg_file rf (IFID_IR[11:10],IFID_IR[9:8],MEMWB_rd,WD,MEMWB_RegWrite,RD1,RD2,clock);
   MainControl MainCtr (IFID_IR[15:12],Control); 
   assign SignExtend = {{8{IFID_IR[7]}},IFID_IR[7:0]}; 
  
// EXE
   reg EXMEM_RegWrite,EXMEM_MemtoReg,
       EXMEM_Branch,  EXMEM_MemWrite;
   wire [15:0] Target;
   reg EXMEM_Zero;
   reg [15:0] EXMEM_Target,EXMEM_ALUOut,EXMEM_RD2;
   reg [15:0] EXMEM_IR; // For monitoring the pipeline
   reg [1:0] EXMEM_rd; // Needs to be checked for 16-bit compliance
   wire [15:0] B,ALUOut;
   // wire [2:0] ALUctl;
   wire [1:0] WR;
   ALU branch (3'b010,IDEX_SignExt<<1,IDEX_PCplus2,Target,Unused2);
   ALU ex (IDEX_ALUOp, IDEX_RD1, B, ALUOut, Zero);
   // ALUControl ALUCtrl(IDEX_ALUOp, IDEX_SignExt[5:0], ALUctl); // ALU control unit
   // assign B  = (IDEX_ALUSrc) ? IDEX_SignExt: IDEX_RD2;        // ALUSrc Mux 
   // assign WR = (IDEX_RegDst) ? IDEX_rd: IDEX_rt;              // RegDst Mux

   mux2x1_2 RegDstMux (IDEX_rt, IDEX_rd, IDEX_RegDst, WR);         // RegDst Mux
   // mux2x1_16 ALUSrcMux (IDEX_RD2, IDEX_SignExt, IDEX_ALUSrc, B);          // ALUSrc Mux
   ALUSrcControl ALUSrcControl1(B, IDEX_RD2, IDEX_SignExt, IDEX_SignExt<<8, IDEX_ALUSrc);

// MEM
   reg MEMWB_RegWrite,MEMWB_MemtoReg;
   reg [15:0] DMemory[0:1023],MEMWB_MemOut,MEMWB_ALUOut;
   reg [15:0] MEMWB_IR; // For monitoring the pipeline
   wire [15:0] MemOut;
   reg [1:0] MEMWB_rd; // Needs to be checked for 16-bit compliance
   assign MemOut = DMemory[EXMEM_ALUOut>>1];
   always @(negedge clock) if (EXMEM_MemWrite) DMemory[EXMEM_ALUOut>>1] <= EXMEM_RD2;
  
// WB
   // assign WD = (MEMWB_MemtoReg) ? MEMWB_MemOut: MEMWB_ALUOut; // MemtoReg Mux
   mux2x1_16 Mem2Reg (MEMWB_ALUOut, MEMWB_MemOut, MEMWB_MemtoReg, WD); // MemtoReg Mux


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
    IFID_PCplus2 <= PCplus2;
    IFID_IR <= IMemory[PC>>1];

// ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,IDEX_ALUOp} <= Control;   
    IDEX_PCplus2 <= IFID_PCplus2;
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[9:8];
    IDEX_rd <= IFID_IR[7:6];

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
  wire [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD");
    $monitor ("%2d  %3d  %h %h %h %h %d", $time,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
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
