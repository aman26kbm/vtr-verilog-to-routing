import sys
import os.path
from os import path
import pdb
import math

data_width = 8
address_width = 7
mem_size = 128

def ceiling_div(a, b):
  if(a == 0):
    return 0
  
  if(a % b == 0):
    return a//b
  
  return a//b + 1

def write_with_ram(file, basic_block_size, final_block_size):
  #write the top module
  num_of_bram = int(int(final_block_size)/int(basic_block_size))
  #num_of_IO   = ceiling_div(num_of_bram*num_of_bram, 4) Sep9
  file.write('module matrix_multiplication(\n')
  file.write('  clk,\n')
  file.write('  clk_mem,\n')
  file.write('  reset,\n')
  file.write('  enable_writing_to_mem,\n'
             '  enable_reading_from_mem,\n'
             '  data_pi,\n'
             '  addr_pi,\n'
             '  we_a,\n'
             '  we_b,\n'
             '  we_c,\n'
             '  data_from_out_mat,\n')
  file.write('  start_mat_mul,\n')
  file.write('  done_mat_mul\n'
  	     ');\n\n')

  #declare the port
  file.write(	'  input clk;\n'
                '  input clk_mem;\n'
                '  input enable_writing_to_mem;\n'
                '  input enable_reading_from_mem;\n'
                '  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_pi;\n'
                '  input [`AWIDTH-1:0] addr_pi;\n'
                '  input we_a;\n'
                '  input we_b;\n'
                '  input we_c;\n'
                '  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;\n'
                '  output done_mat_mul;\n\n')
  file.write('  input reset;\n')
  file.write('  input start_mat_mul;\n')
  
  num_of_bram = int(int(final_block_size)/int(basic_block_size))
  #print('num of bram is {0}\n'.format(num_of_bram))
  file.write(	'  reg enable_writing_to_mem_reg;\n'
  			'  reg enable_reading_from_mem_reg;\n'
  			'  reg [`AWIDTH-1:0] addr_pi_reg;\n'
  			'  always @(posedge clk_mem) begin\n'
  			'    if(reset) begin\n'
  			'      enable_writing_to_mem_reg <= 0;\n'
  			'      enable_reading_from_mem_reg <= 0;\n'
  			'      addr_pi_reg <= 0;\n'
  			'    end else begin\n'
  			'      enable_writing_to_mem_reg <= enable_writing_to_mem;\n'
  			'      enable_reading_from_mem_reg <= enable_reading_from_mem;\n'
  			'      addr_pi_reg <= addr_pi;\n'
  			'    end\n'
  			'  end\n')
  
  
  
  #matrix A
  file.write(	'/////////////////////////////////////////////////\n'
  			'// BRAMs to store matrix A\n'
  			'/////////////////////////////////////////////////\n\n')
  #pdb.set_trace()
  #delcare the wire
  for i in range(num_of_bram):
    file.write( '  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_{0}_0;\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
    file.write( '  wire [`AWIDTH-1:0] a_addr_{0}_0;\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
    file.write(	'  wire [`AWIDTH-1:0] a_addr_muxed_{0}_0;\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
    file.write(	'  reg  [`AWIDTH-1:0] a_addr_muxed_{0}_0_reg;\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
    file.write(	'  reg  [`AWIDTH-1:0] a_addr_{0}_0_reg;\n'.format(i))
  file.write('\n\n')
  
  
  
  file.write(   '  always @(posedge clk_mem) begin\n'
  		'    if(reset) begin\n')
  for i in range(num_of_bram):
    file.write(	'      a_addr_{0}_0_reg <= 0;\n'.format(i))
  for i in range(num_of_bram):
    file.write(	'      a_addr_muxed_{0}_0_reg <= 0;\n'.format(i))
  file.write(		'    end else begin\n')
  for i in range(num_of_bram):
    file.write(	'      a_addr_{0}_0_reg <= a_addr_{0}_0;\n'.format(i))
  for i in range(num_of_bram):
    file.write(	'      a_addr_muxed_{0}_0_reg <= a_addr_muxed_{0}_0;\n'.format(i))
  file.write(	'    end\n')
  file.write(	'  end\n\n')
  
  
  for i in range(num_of_bram):
    file.write(	'  assign a_addr_muxed_{0}_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_{0}_0_reg;\n'.format(i))
  
  file.write(	'\n')
  for i in range(num_of_bram):
    file.write(	'  // BRAM matrix A {0}_0\n'
  		'  ram matrix_A_{0}_0 (\n'
  		'    .addr0(a_addr_muxed_{0}_0_reg),\n'
  		'    .d0(data_pi),\n'
  		'    .we0(we_a),\n'
  		'    .q0(a_data_{0}_0),\n'
  		'    .clk(clk_mem));\n\n'
  		.format(i))

  for i in range(num_of_bram):
    file.write( '  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_{0}_0_reg;\n'.format(i))
  
  file.write(  '  always @(posedge clk_mem) begin\n')
  file.write(  '    if (reset) begin\n')
  for i in range(num_of_bram):
    file.write('      a_data_{0}_0_reg <= 0;\n'.format(i))
  file.write(  '    end else begin\n;')
  for i in range(num_of_bram):
    file.write('      a_data_{0}_0_reg <= a_data_{0}_0;\n'.format(i))
  file.write(  '    end\n')
  file.write(  '  end\n\n')
  
  #matrixB
  file.write(	'/////////////////////////////////////////////////\n'
  		'// BRAMs to store matrix B\n'
  		'/////////////////////////////////////////////////\n\n')
  
  for i in range(num_of_bram):
  	file.write(	'  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_{0};\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
  	file.write(	'  wire [`AWIDTH-1:0] b_addr_0_{0};\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
  	file.write(	'  wire [`AWIDTH-1:0] b_addr_muxed_0_{0};\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
  	file.write(	'  reg  [`AWIDTH-1:0] b_addr_muxed_0_{0}_reg;\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
  	file.write(	'  reg  [`AWIDTH-1:0] b_addr_0_{0}_reg;\n'.format(i))
  file.write('\n')
  file.write('\n\n')
  
  
  file.write(		'  always @(posedge clk_mem) begin\n'
  				'    if(reset) begin\n')
  for i in range(num_of_bram):
  	file.write(	'      b_addr_0_{0}_reg <= 0;\n'.format(i))
  for i in range(num_of_bram):
  	file.write(	'      b_addr_muxed_0_{0}_reg <= 0;\n'.format(i))
  file.write(		'    end else begin\n')
  for i in range(num_of_bram):
  	file.write(	'      b_addr_0_{0}_reg <= b_addr_0_{0};\n'.format(i))
  for i in range(num_of_bram):
  	file.write(	'      b_addr_muxed_0_{0}_reg <= b_addr_muxed_0_{0};\n'.format(i))
  file.write(		'    end\n')
  file.write(		'  end\n\n')
  
  for i in range(num_of_bram):
  	file.write(	'  assign b_addr_muxed_0_{0} = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_{0}_reg;\n'.format(i))
  
  file.write(		'\n')
  for i in range(num_of_bram):
  	file.write(	'  // BRAM matrix B 0_{0}\n'
  				'  ram matrix_B_0_{0} (\n'
  				'    .addr0(b_addr_muxed_0_{0}_reg),\n'
  				'    .d0(data_pi),\n'
  				'    .we0(we_b),\n'
  				'    .q0(b_data_0_{0}),\n'
  				'    .clk(clk_mem));\n\n'
                                .format(i))

  for i in range(num_of_bram):
    file.write( '  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_{0}_reg;\n'.format(i))
  
  file.write(  '  always @(posedge clk_mem) begin\n')
  file.write(  '    if (reset) begin\n')
  for i in range(num_of_bram):
    file.write('      b_data_0_{0}_reg <= 0;\n'.format(i))
  file.write(  '    end else begin\n;')
  for i in range(num_of_bram):
    file.write('      b_data_0_{0}_reg <= b_data_0_{0};\n'.format(i))
  file.write(  '    end\n')
  file.write(  '  end\n\n')
  
  #matrixC
  file.write(	'/////////////////////////////////////////////////\n'
  		'// BRAMs to store matrix C\n'
  		'/////////////////////////////////////////////////\n\n')
  
  file.write('  reg [`AWIDTH-1:0] c_addr;\n')
  file.write('\n')
  for i in range(num_of_bram):
    file.write('  wire [`AWIDTH-1:0] c_addr_muxed_0_{0};\n'.format(i))
  for i in range(num_of_bram):
    file.write('  reg  [`AWIDTH-1:0] c_addr_muxed_0_{0}_reg;\n'.format(i))
  file.write('\n')
  for i in range(num_of_bram):
    file.write('  assign c_addr_muxed_0_{0} = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;\n'.format(i))
  file.write('\n')
  file.write(	'  always @(posedge clk_mem) begin\n'
  			'    if(reset || done_mat_mul) begin\n'
  			'      c_addr <= 0;\n'
  			'    end\n'
  			'    else if (start_mat_mul) begin\n'
  			'      c_addr <= c_addr + 1;\n'
  			'    end\n'
  			'  end\n\n')

  for i in range(num_of_bram):
    file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_{0};\n'.format(i))
  
  for i in range(num_of_bram):
    file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_{0};\n'.format(i))
  file.write('\n')

  file.write('///////////////// ORing the data ///////////////////\n\n')
  file.write('  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;\n')
  for i in range(num_of_bram):
    if(i == 0 or i == num_of_bram - 1):
      continue;
    file.write('  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_{0};\n'.format(i))
  for i in range(num_of_bram):
    file.write('  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_{0}_reg;\n'.format(i))
  file.write('\n')
  
  file.write(  '  always @(posedge clk_mem) begin\n'
  	       '    if(reset) begin\n')

  for i in range(num_of_bram):
    file.write('      data_from_out_mat_0_{0}_reg <= 0;\n'.format(i))
  
  file.write(  '    end else begin\n')
  for i in range(num_of_bram):
    file.write('      data_from_out_mat_0_{0}_reg <= data_from_out_mat_0_{0};\n'.format(i))
  file.write(  '    end\n'
  	       '  end\n\n')
  
  #oring the data
  file.write(	 '  always @(posedge clk_mem) begin\n'
  		 '    if(reset) begin\n'
  		 '      data_from_out_mat <= 0;\n')
  for i in range(num_of_bram):
    if(i == 0 or i == num_of_bram - 1):
      continue;
    file.write(	 '      c_reg_{0} <= 0;\n'.format(i))
  file.write(			'    end else begin\n')
  for i in range(num_of_bram):
    if(num_of_bram == 2):
      file.write('       data_from_out_mat <= data_from_out_mat_0_1 | data_from_out_mat_0_0;\n')
      break
    if(i == 0):
      continue;
    elif(i == 1):
      file.write('      c_reg_1 <= data_from_out_mat_0_0_reg | data_from_out_mat_0_1_reg;\n')
    elif( i == num_of_bram - 1):
      file.write('      data_from_out_mat <= c_reg_{0} | data_from_out_mat_0_{1}_reg;\n'.format(i-1, i))
    else:
      file.write('      c_reg_{0} <= c_reg_{1} | data_from_out_mat_0_{2}_reg;\n'.format(i, i-1, i))
  file.write(	 '    end\n')
  file.write(	 '  end\n\n')
  
  
  for i in range(num_of_bram):
    file.write('  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_{0}_reg;\n'.format(i))
  
  file.write( 	'  always @(posedge clk_mem) begin\n'
  		'    if(reset) begin\n')
  for i in range(num_of_bram):
    file.write(	'      c_data_row_{0}_reg <= 0;\n'
  		'      c_addr_muxed_0_{0}_reg <= 0;\n'.format(i))
  file.write(   '    end else begin\n')
  for i in range(num_of_bram):
    file.write(	'      c_data_row_{0}_reg <= c_data_row_{0};\n'
  	        '      c_addr_muxed_0_{0}_reg <= c_addr_muxed_0_{0};\n'.format(i))
  file.write(	'    end\n'
  		'  end\n\n')
  
  for i in range(num_of_bram):
    file.write(	'  //  BRAM matrix C row_{0}\n'
   		'  ram matrix_row_{0} (\n'
    		'    .addr0(c_addr_muxed_0_{0}_reg),\n'
    		'    .d0(c_data_row_{0}_reg),\n'
    		'    .we0(we_c),\n'
    		'    .q0(data_from_out_mat_0_{0}),\n'
    		'    .clk(clk_mem));\n\n'
    		.format(i))
  
  #instantiation of systolic matmul
  file.write(	'/////////////////////////////////////////////////\n'
  		'// The {0}x{0} matmul instantiation\n'
  		'/////////////////////////////////////////////////\n\n'
  		.format(final_block_size))
  
  file.write(	'matmul_{0}x{0}_systolic u_matmul_{0}x{0}_systolic (\n'
  		'  .clk(clk),\n  .done_mat_mul(done_mat_mul),\n'.format(final_block_size))
  file.write(	'  .reset(reset),\n')
  file.write(	'  .start_mat_mul(start_mat_mul),\n')
  	
  
  for i in range(num_of_bram):
    file.write(	'  .a_data_{0}_0(a_data_{0}_0_reg),\n'
  		'  .a_addr_{0}_0(a_addr_{0}_0),\n'
  		'  .b_data_0_{0}(b_data_0_{0}_reg),\n'
  		'  .b_addr_0_{0}(b_addr_0_{0}),\n'
  		.format(i))
  
  file.write('\n')
  
  for i in range(num_of_bram):
    if(i == num_of_bram - 1):
      continue
    file.write(	'  .c_data_row_{0}(c_data_row_{0}),\n'.format(i))
  file.write(	'  .c_data_row_{0}(c_data_row_{0})\n'
   		');\n'
   		'endmodule\n\n\n'
   		.format(num_of_bram - 1))

#three modules
def write_systolic_matmul(file, basic_block_size, final_block_size):
  num_of_bram = int(int(final_block_size)/int(basic_block_size))
  num_of_IO   = ceiling_div(num_of_bram*num_of_bram, 4)
  file.write('module matmul_{0}x{0}_systolic(\n'
  	     '  clk,\n  done_mat_mul,\n'.format(final_block_size))  
  file.write('  reset,\n')
  file.write('  start_mat_mul,\n')
  
  for i in range(num_of_bram):
    file.write('  a_data_{0}_0,\n'
  	       '  a_addr_{0}_0,\n'
  	       '  b_data_0_{0},\n'
  	       '  b_addr_0_{0},\n'
               .format(i))
  
  file.write('\n')
  
  #Sep 1
  for i in range(num_of_bram):
    if (i == num_of_bram - 1):
      continue
    file.write('  c_data_row_{0},\n'.format(i))
  file.write(  '  c_data_row_{0}\n'
  	       ');\n'.format(num_of_bram - 1))
  
  file.write(  '  input clk;\n' 
  	       '  output done_mat_mul;\n\n')
  
  file.write(  '  input reset;\n')
  file.write(  '  input start_mat_mul;\n')
  
  #input A data
  for i in range(num_of_bram):
    file.write('  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_{0}_0;\n'.format(i))
  file.write('\n')
  
  #input B data
  for i in range(num_of_bram):
    file.write('  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_{0};\n'.format(i))
  file.write('\n')
  
  #output C data
  for i in range(num_of_bram):
    file.write('  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_{0};\n'.format(i))
  file.write('\n')
  
  #output A addr
  for i in range(num_of_bram):
    file.write('  output [`AWIDTH-1:0] a_addr_{0}_0;\n'.format(i))
  file.write('\n')
  
  #output B addr
  for i in range(num_of_bram):
    file.write('  output [`AWIDTH-1:0] b_addr_0_{0};\n'.format(i))
  file.write('\n')
  
  file.write('  /////////////////////////////////////////////////\n'
  	     '  // ORing all done signals\n'
  	     '  /////////////////////////////////////////////////\n')
  for i in range(num_of_bram):
    for j in range(num_of_bram):
      file.write('  wire done_mat_mul_{0}_{1};\n'.format(i, j))
  file.write('\n')
  file.write('  assign done_mat_mul = ')
  
  file.write('done_mat_mul_0_0;\n\n')
  
  #instaniate 4x4 matmul
  for i in range(num_of_bram):
    for j in range(num_of_bram):
      file.write('  /////////////////////////////////////////////////\n'
  		 '  // Matmul {0}_{1}\n'
  		 '  /////////////////////////////////////////////////\n\n'.format(i, j))
      #declare wire
      file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_{a}_{b}_to_{a}_{c};\n'
  		 '  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_{a}_{b}_to_{d}_{b};\n'.format(a=i,b=j,c=j+1,d=i+1))
  
      if(j != 0):
        file.write('  wire [`AWIDTH-1:0] a_addr_{0}_{1}_NC;\n'.format(i, j))
      if(i != 0):
        file.write('  wire [`AWIDTH-1:0] b_addr_{0}_{1}_NC;\n'.format(i, j))
  
      if(j != 0):
        file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_{0}_{1}_NC;\n'.format(i,j))
      if(i != 0):
        file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_{0}_{1}_NC;\n'.format(i,j))
  
      if(j == 0):
        file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_{0}_{1}_NC;\n'.format(i,j))
      if(i == 0):
        file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_{0}_{1}_NC;\n'.format(i,j))
  
      #Sep 1
      if(j != num_of_bram - 1):
        file.write('  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_{a}_{b}_to_{c}_{d};\n'.format(a = i, b = j, c = i, d =j+1))
  
      #instantiate the basic building block matmul
      #tt = int((i * num_of_bram + j)/4)
      file.write('\n')
      file.write('matmul_{c}x{c}_systolic u_matmul_{c}x{c}_systolic_{a}_{b}(\n'
  		 '  .clk(clk),\n'
  		 '  .reset(reset),\n'
  		 '  .start_mat_mul(start_mat_mul),\n'
  		 '  .done_mat_mul(done_mat_mul_{a}_{b}),\n'.format(a = i, b = j, c = basic_block_size))
  
      if(j == 0):
        file.write('  .a_data(a_data_{0}_{1}),\n'.format(i,j))
      else:
        file.write('  .a_data(a_data_{0}_{1}_NC),\n'.format(i,j))
  
      if(i == 0):
        file.write('  .b_data(b_data_{0}_{1}),\n'.format(i, j))
      else:
        file.write('  .b_data(b_data_{0}_{1}_NC),\n'.format(i,j))
  
      if(j == 0):
        file.write('  .a_data_in(a_data_in_{0}_{1}_NC),\n'.format(i,j))
      else:
        file.write('  .a_data_in(a_data_{0}_{2}_to_{0}_{1}),\n'.format(i,j,j-1))
  
      if(i == 0):
        file.write('  .b_data_in(b_data_in_{0}_{1}_NC),\n'.format(i,j))
      else:
        file.write('  .b_data_in(b_data_{2}_{1}_to_{0}_{1}),\n'.format(i,j,i-1))
  
      if(j == 0):
        file.write('  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1\'b0}}),\n')
      else:
        file.write('  .c_data_in(c_data_{a}_{b}_to_{c}_{d}),\n'.format(a = i, b = j - 1, c = i, d = j))
  
      if(j == num_of_bram - 1):
        file.write('  .c_data_out(c_data_row_{0}),\n'.format(i))
      else:
        file.write('  .c_data_out(c_data_{a}_{b}_to_{c}_{d}),\n'.format(a = i, b = j, c = i, d = j + 1))
        # file.write(	'  .c_data(c_data_{a}_{b}),\n'
        file.write(	'  .a_data_out(a_data_{a}_{b}_to_{a}_{c}),\n'
  					'  .b_data_out(b_data_{a}_{b}_to_{d}_{b}),\n'
  		 			.format(a=i, b=j, c=j+1, d=i+1))
  
      if(j != 0):
        file.write('  .a_addr(a_addr_{0}_{1}_NC),\n'.format(i, j))
      else:
        file.write('  .a_addr(a_addr_{0}_{1}),\n'.format(i, j))
  
      if(i != 0):
        file.write('  .b_addr(b_addr_{0}_{1}_NC),\n'.format(i, j))
      else:
        file.write('  .b_addr(b_addr_{0}_{1}),\n'.format(i, j))
  
  		#Sep 1
  		#file.write(	'  .c_addr(c_addr_{0}_{1}),\n'
      file.write(	'  .final_mat_mul_size(8\'d{2}),\n'
  					'  .a_loc(8\'d{0}),\n'
  					'  .b_loc(8\'d{1})\n'
  					');\n\n'
  					.format(i, j, final_block_size))
  
  file.write('endmodule\n\n')

def write_ram_module(file):
  file.write('module ram (addr0, d0, we0, q0, clk);\n\n'
             'input [`AWIDTH-1:0] addr0;\n'
             'input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] d0;\n'
             'input we0;\n'
             'output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] q0;\n'
             'input clk;\n\n'
             
             'single_port_ram u_single_port_ram(\n'
             '  .data(d0),\n'
             '  .we(we0),\n'
             '  .addr(addr0),\n'
             '  .clk(clk),\n'
             '  .out(q0)\n'
             ');\n'
             'endmodule')


def main():
#file I/O
  with_ram = 0
  #pdb.set_trace()
  try:
    basic_block_size = sys.argv[1]
    final_block_size = sys.argv[2]
    output_filename  = sys.argv[3]
    if(sys.argv[4] == 'yes'):
      with_ram = 1
    elif(sys.argv[4] == 'no'):
      with_ram = 0
    else:
      exit(3)
  except:
      print('please follow the use: python3 MatMulScale.py [basic_block_size] [final_block_size] [output_filename.v] [with_ram: yes or no]')
      exit(0)
  
  try:
    file = open(output_filename, 'w+')
  except:
    print('faild to create the file ' + output_filename)
    exit(1)
  
  #write the definition
  file.write(	'`timescale 1ns/1ns\n'
  		'`define DWIDTH {}\n'
  		'`define AWIDTH {}\n'
  		'`define MEM_SIZE {}\n'
  		'`define MAT_MUL_SIZE {}\n'
  		'`define LOG2_MAT_MUL_SIZE 2\n'
  		'`define BB_MAT_MUL_SIZE `MAT_MUL_SIZE\n'
  		'`define NUM_CYCLES_IN_MAC 3\n\n\n'
  		.format(data_width, address_width, mem_size, basic_block_size))
  
  #with bram module
  if(with_ram == 1):
    write_with_ram(file, basic_block_size, final_block_size)
  
  
  #systolic impplementation
  file.write('/////////////////////////////////////////////////\n'
  	     '// The {0}x{0} matmul definition\n'
  	     '/////////////////////////////////////////////////\n\n'
  	     .format(final_block_size))
  
  write_systolic_matmul(file, basic_block_size, final_block_size)
  if(with_ram == 1):
    write_ram_module(file)
  file.close()

main()



