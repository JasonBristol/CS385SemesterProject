// Simplified version of MIPS register file (4 registers, 1-bit data)

// For the project MIPS (4-registers, 16-bit data):
//  1. Change the D flip-flops with 16-bit registers
//  2. Redesign mux4x1 using gate-level modeling


module reg_file (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);

  input [1:0] rr1,rr2,wr;
  input wd;
  input regwrite,clock;
  output rd1,rd2;

  // registers

  D_flip_flop r1 (wd,c1,q1);
  D_flip_flop r2 (wd,c2,q2);
  D_flip_flop r3 (wd,c3,q3);
  D_flip_flop r4 (wd,c4,q4);

  // output port

  mux4x1 mux1 (0,q1,q2,q3,rr1,rd1),
         mux2 (0,q1,q2,q3,rr2,rd2);

  // input port

  decoder dec(wr[1],wr[0],w3,w2,w1,w0);

  and a (regwrite_and_clock,regwrite,clock);

  and a1 (c1,regwrite_and_clock,w1),
      a2 (c2,regwrite_and_clock,w2),
      a3 (c3,regwrite_and_clock,w3);

endmodule


// Components

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


module testing ();

  reg [1:0] rr1,rr2,wr;
  reg wd;
  reg regwrite, clock;
  wire rd1,rd2;

  reg_file regs (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);

  initial 
    begin  

      #10 regwrite=1; //enable writing

      #10 wd=0;       // set write data

      #10      rr1=0;rr2=0;clock=0;
      #10 wr=1;rr1=1;rr2=1;clock=1;
      #10                  clock=0;
      #10 wr=2;rr1=2;rr2=2;clock=1;
      #10                  clock=0;
      #10 wr=3;rr1=3;rr2=3;clock=1;
      #10                  clock=0; 

      #10 regwrite=0; //disable writing

      #10 wd=1;       // set write data

      #10 wr=1;rr1=1;rr2=1;clock=1;
      #10                  clock=0;
      #10 wr=2;rr1=2;rr2=2;clock=1;
      #10                  clock=0;
      #10 wr=3;rr1=3;rr2=3;clock=1;
      #10                  clock=0;

      #10 regwrite=1; //enable writing

      #10 wd=1;       // set write data

      #10 wr=1;rr1=1;rr2=1;clock=1;
      #10                  clock=0;
      #10 wr=2;rr1=2;rr2=2;clock=1;
      #10                  clock=0;
      #10 wr=3;rr1=3;rr2=3;clock=1;
      #10                  clock=0;

  end 

  initial
    $monitor ("regwrite=%d clock=%d rr1=%d rr2=%d wr=%d wd=%d rd1=%d rd2=%d",regwrite,clock,rr1,rr2,wr,wd,rd1,rd2);
 
endmodule 


/* Test results

C:\Verilog>iverilog -o t regfile.vl

C:\Verilog>vvp t
regwrite=x clock=x rr1=x rr2=x wr=x wd=x rd1=x rd2=x
regwrite=1 clock=x rr1=x rr2=x wr=x wd=x rd1=x rd2=x
regwrite=1 clock=x rr1=x rr2=x wr=x wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=0 rr2=0 wr=x wd=0 rd1=0 rd2=0
regwrite=1 clock=1 rr1=1 rr2=1 wr=1 wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=1 rr2=1 wr=1 wd=0 rd1=0 rd2=0
regwrite=1 clock=1 rr1=2 rr2=2 wr=2 wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=2 rr2=2 wr=2 wd=0 rd1=0 rd2=0
regwrite=1 clock=1 rr1=3 rr2=3 wr=3 wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=3 rr2=3 wr=3 wd=0 rd1=0 rd2=0
regwrite=0 clock=0 rr1=3 rr2=3 wr=3 wd=0 rd1=0 rd2=0
regwrite=0 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=0 clock=1 rr1=1 rr2=1 wr=1 wd=1 rd1=0 rd2=0
regwrite=0 clock=0 rr1=1 rr2=1 wr=1 wd=1 rd1=0 rd2=0
regwrite=0 clock=1 rr1=2 rr2=2 wr=2 wd=1 rd1=0 rd2=0
regwrite=0 clock=0 rr1=2 rr2=2 wr=2 wd=1 rd1=0 rd2=0
regwrite=0 clock=1 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=0 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=1 clock=1 rr1=1 rr2=1 wr=1 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=1 rr2=1 wr=1 wd=1 rd1=1 rd2=1
regwrite=1 clock=1 rr1=2 rr2=2 wr=2 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=2 rr2=2 wr=2 wd=1 rd1=1 rd2=1
regwrite=1 clock=1 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=1 rd2=1

*/

