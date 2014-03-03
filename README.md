CS 385 Semester Project
====================

<p><b><u>Description:</u></b> Design a simplified version of a MIPS machine and write <b>Verilog programs </b>that describe its structure and simulate its functioning. Use <b>structural (gate level) modeling</b> for all components unless otherwise specified. The machine should
include the following components:</p>
                                     
<ol>
  <li><u>General purpose registers (register file):</u> 4  registers, 16-bit long, numbered 0 - 3. Register $0 must contain 0 (read-only). Implemented by D flip-flops with gate-level modeling.</li>
  <li> <u>Other registers:</u> 16-bit program counter, pipeline registers. Implemented by reg vectors in Verilog.</li>
  <li> <u>Istruction Memory.</u> Word size: 16 bits, word addressed, size: 1024 bytes. Implemented by reg vectors in Verilog.</li>
  <li> <u>Data Memory.</u> Word size: 16 bits, byte addressed, size: 1024 bytes. Implemented by reg vectors in Verilog.</li>
  <li> <u>Data Cache (optional):</u> direct mapped, write-through, 16-bit block size, size: 8 blocks. Any kind of Verilog model accepted.</li>
  <li> <u>ALU:</u> 16-bit data, 3-bit control. Functions: and, or, add, sub, slt.</li>
  <li> <u>Control unit:</u> may be implemented by behavioral modeling.</li>
  <li> <u>Other components necessary to connect the main components:</u> multiplexes and decoders implemented by gate-level modeling.</li>
                                       
</ol>
  <b><u>Instruction set</u></b>
  </br>                    
  <table>
    <thead><tr><th>Instruction</th><th>Opcode</th></tr></thead>
    <tbody>
      <tr><td>add</td><td>0000</td></tr>
      <tr><td>sub</td><td>0001</td></tr>
      <tr><td>and</td><td>0010</td></tr>
      <tr><td>or</td><td>0011</td></tr>
      <tr><td>addi</td><td>0100</td></tr>
      <tr><td>lw</td><td>0101</td></tr>
      <tr><td>sw</td><td>0110</td></tr>
      <tr><td>slt</td><td>0111</td></tr>
      <tr><td>beq</td><td>1000</td></tr>
      <tr><td>bne</td><td>1001</td></tr>
    </tbody>                   
</table>
                                        
<p><b><u>Instruction formats:</u></b></p>
                                     
<p>
	<span>R-format (add, sub, and, or, slt)</span>
	</br>                   
  <table>
    <thead><tr><th>op</th><th>rs</th><th>rt</th><th>rd</th><th>unused</th></tr></thead>
    <tbody>
      <tr><td>4</td><td>2</td><td>2</td><td>2</td><td>6</td></tr>
    </tbody>                   
  </table>
</p>
                                     
<p>
	<span>I-format (addi, lw, sw, beq, bne)</span> 
	</br>                   
  <table>
  	<thead><tr><th>op</th><th>rs</th><th>rt</th><th>address / value</th></tr></thead>
    <tbody>
      <tr><td>4</td><td>2</td><td>2</td><td>8</td></tr>
    </tbody>                   
  </table>
</p>
                                     
<p><b><u>Restrictions:</u></b> </p>
                                     
<ol>
  <li>Use <b>structural (gate level) modeling</b> for all components except for the program counter, memories, and pipeline registers.</li>
  <li>Implement a pipelined datapath and control.</li>
</ol>
<b><u>Extra credit (maximum 5 points):</u></b> Implementing a carry lookahead logic for the ALU, a data cache, additional MIPS instructions, or improvements of the pipeline (forwarding or stalling). 