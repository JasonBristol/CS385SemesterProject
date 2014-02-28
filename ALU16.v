// 16-bit MIPS ALU in Verilog

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
  // reg OUT; 
  // always @ (select or A or B) 
  //   if (select == 0) OUT = A;
  //   else OUT = B;

  // This should work
  not not1(i0, select);
  and and1(i1, A, i0);
  and and2(i2, B, select);
  or or1(OUT, i1, i2);
endmodule 


module mux4x1(i0,i1,i2,i3,select,y); 
  input i0,i1,i2,i3; 
  input [1:0] select; 
  output y; 
  // reg y; 
  // always @ (i0 or i1 or i2 or i3 or select) 
  //   case (select) 
  //     2'b00: y = i0; 
  //     2'b01: y = i1; 
  //     2'b10: y = i2; 
  //     2'b11: y = i3; 
  //   endcase

  // This should work
  mux2x1 mux1(i0, i1, select[0], m1);
  mux2x1 mux2(i2, i3, select[0], m2);
  mux2x1 mux3(m1, m2, select[1], y);
endmodule 


// Testbench

module testALU;
  reg [15:0] a;
  reg [15:0] b;
  reg [2:0] op;
  wire [15:0] result;
  wire zero;
	
  ALU alu (op,a,b,result,zero);
	
  initial
    begin

      // Test 16-bit values
      op = 3'b000; a = 16'b0000000000000111; b = 16'b0000000000000001;  // AND
	#10 op = 3'b001; a = 16'b0000000000000101; b = 16'b0000000000000010;  // OR

	#10 op = 3'b010; a = 16'b0000000000000101; b = 16'b0000000000000001;  // ADD
	#10 op = 3'b010; a = 16'b0000000000000111; b = 16'b0000000000000001;  // ADD
	#10 op = 3'b110; a = 16'b0000000000000101; b = 16'b0000000000000001;  // SUB
	#10 op = 3'b110; a = 16'b0000000000001111; b = 16'b0000000000000001;  // SUB
	#10 op = 3'b111; a = 16'b0000000000000101; b = 16'b0000000000000001;  // SLT
	#10 op = 3'b111; a = 16'b0000000000001110; b = 16'b0000000000001111;  // SLT

    end

  initial
    $monitor ("op=%b a=%b b=%b result=%b zero=%b",op,a,b,result,zero);

endmodule


/* Test Results for 4-bit ALU

C:\Verilog>iverilog -o alu4 ALU4.v

C:\Verilog>vvp alu4
op = 000 a = 0111 b = 0001 result = 0001 zero = 0
op = 001 a = 0101 b = 0010 result = 0111 zero = 0
op = 010 a = 0101 b = 0001 result = 0110 zero = 0
op = 010 a = 0111 b = 0001 result = 1000 zero = 0
op = 110 a = 0101 b = 0001 result = 0100 zero = 0
op = 110 a = 1111 b = 0001 result = 1110 zero = 0
op = 111 a = 0101 b = 0001 result = 0000 zero = 1
op = 111 a = 1110 b = 1111 result = 0001 zero = 0

*/

/* Test Results for 16-bit ALU

C:\Verilog>iverilog -o alu16 ALU16.v

C:\Verilog>vvp alu16
op=000 a=0000000000000111 b=0000000000000001 result=0000000000000001 zero=0
op=001 a=0000000000000101 b=0000000000000010 result=0000000000000111 zero=0
op=010 a=0000000000000101 b=0000000000000001 result=0000000000000110 zero=0
op=010 a=0000000000000111 b=0000000000000001 result=0000000000001000 zero=0
op=110 a=0000000000000101 b=0000000000000001 result=0000000000000100 zero=0
op=110 a=0000000000001111 b=0000000000000001 result=0000000000001110 zero=0
op=111 a=0000000000000101 b=0000000000000001 result=0000000000000000 zero=1
op=111 a=0000000000001110 b=0000000000001111 result=0000000000000001 zero=0

*/