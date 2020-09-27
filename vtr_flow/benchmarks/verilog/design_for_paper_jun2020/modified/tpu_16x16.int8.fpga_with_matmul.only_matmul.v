`define MATMUL_SIZE_8


`define DESIGN_SIZE_16


//////////////////////////

//../design_organized/defines.v 

//////////////////////////

`define DWIDTH 8
`define AWIDTH 10
`define MEM_SIZE 1024

`ifdef MATMUL_SIZE_4
`define MAT_MUL_SIZE 4
`define MASK_WIDTH 4
`define LOG2_MAT_MUL_SIZE 2
`endif

`ifdef MATMUL_SIZE_8
`define MAT_MUL_SIZE 8
`define MASK_WIDTH 8
`define LOG2_MAT_MUL_SIZE 3
`endif

`ifdef MATMUL_SIZE_16
`define MAT_MUL_SIZE 16
`define MASK_WIDTH 16
`define LOG2_MAT_MUL_SIZE 4
`endif

`ifdef MATMUL_SIZE_32
`define MAT_MUL_SIZE 32
`define MASK_WIDTH 32
`define LOG2_MAT_MUL_SIZE 5
`endif

`ifdef DESIGN_SIZE_4
`define DESIGN_SIZE 4
`define LOG2_DESIGN_SIZE 2
`endif

`ifdef DESIGN_SIZE_8
`define DESIGN_SIZE 8
`define LOG2_DESIGN_SIZE 3
`endif

`ifdef DESIGN_SIZE_16
`define DESIGN_SIZE 16
`define LOG2_DESIGN_SIZE 4
`endif

`ifdef DESIGN_SIZE_32
`define DESIGN_SIZE 32
`define LOG2_DESIGN_SIZE 5
`endif

`define NUM_CYCLES_IN_MAC 3
`define MEM_ACCESS_LATENCY 1
`define REG_DATAWIDTH 32
`define REG_ADDRWIDTH 8
`define ADDR_STRIDE_WIDTH 16
`define MAX_BITS_POOL 3

/////////////////////////////////////////////////
//How to use fully-connected mode?
/////////////////////////////////////////////////
//TODO: See layer test and accum test and write documentation

/////////////////////////////////////////////////
//How to use convolution mode?
/////////////////////////////////////////////////

//Matrix A (input activation matrix)
//----------------------------------
//* This matrix is the non-expanded matrix (ie. this contains 
//  the same number of elements as the input activation tensor).
//  It doesn't contain the expanded GEMM M matrix corresponding
//  to this convolution.
//* This matrix is expected to have been padded though. That is,
//  if there are any padding rows/columns to be added, the software
//  should do that and store the padded matrix in the BRAM. 
//* Initial address of matrix A is to be programmed once in the
//  beginning of calculation of each output tile. We don't have 
//  to reprogram the address of A every time during accumulation.
//* The register containing stride of the matrix A is not used 
//  in convolution mode. Address strides for each read are determined
//  on the basis of C,R,S values internally in the RTL. This is because
//  strides are not fixed. They vary for every read.
//* This matrix is laid out in NCHW format. 

//Matrix B (weight matrix)
//----------------------------------
//* This matrix is the non-expanded matrix (ie. this contains 
//  the same number of elements as the weight tensor).
//  It doesn't contain the expanded GEMM N matrix corresponding
//  to this convolution.
//* There is no concept of padding for this matrix.
//* Initial address of matrix B is to be programmed once in the
//  beginning of calculation of each output tile. We don't have 
//  to reprogram the address of B every time during accumulation.
//* The register containing stride of the matrix B is not used
//  in the RTL. Address strides for each read are determined
//  on the basis of C,R,S values internally in the RTL. 
//* This matrix is laid out in NCHW format, but it is transposed.
//  So technically, the format is WHCN. 

//Matrix C (output activation matrix)
//----------------------------------
//* This matrix is the non-expanded matrix (ie. this contains 
//  the same number of elements as the output activation tensor).
//  It contains the GEMM matrix corresponding
//  to this convolution.
//* There is no concept of padding for this matrix.
//* Initial address of matrix C is to be programmed in the
//  beginning of calculation of each output tile. 
//  There is no concept of programming the address of C for 
//  accumulation. We write the matrix C only after all accumulations
//  have finished.
//* The register containing stride of the matrix C is not used
//  in the RTL. That is because the stride is known and is equal to
//  out_img_width * out_img_height, and RTL just uses that directly.
//* This matrix is laid out in NCHW format.

/////////////////////////////////////////////////
//Register specification
/////////////////////////////////////////////////
//---------------------------------------
//Addr 0 : Register with enables for various blocks. 
//Includes mode of operation (convolution or fully_connected)
//---------------------------------------
`define REG_ENABLES_ADDR 32'h0
//Bit 0: enable_matmul
//Bit 1: enable_norm
//Bit 2: enable_pool
//Bit 3: enable_activation
//Bit 31: enable_conv_mode

//---------------------------------------
//Addr 4: Register that triggers the whole TPU
//---------------------------------------
`define REG_STDN_TPU_ADDR 32'h4
//Bit 0: start_tpu
//Bit 31: done_tpu

//---------------------------------------
//Addr 8: Register that stores the mean of the values
//---------------------------------------
`define REG_MEAN_ADDR 32'h8
//Bit 7:0: mean

//---------------------------------------
//Addr A: Register that stores the inverse variance of the values
//---------------------------------------
`define REG_INV_VAR_ADDR 32'hA
//Bit 7:0: inv_var

//---------------------------------------
//Addr E: Register that stores the starting address of matrix A in BRAM A.
//In fully-connected mode, this register should be programmed with the
//address of the matrix being currently multiplied. That is, the 
//address of the matrix of the matmul. So, this register will be
//programmed every time the matmul is kicked off during accumulation stages.
//Use the STRIDE registers to tell the matmul to increment addresses.
//In convolution mode, this register should be programmed with the 
//address of the input activation matrix. No need to configure
//this every time the matmul is kicked off for accmulation. Just program it 
//once it the beginning. Address increments are handled automatically .
//---------------------------------------
`define REG_MATRIX_A_ADDR 32'he
//Bit `AWIDTH-1:0 address_mat_a

//---------------------------------------
//Addr 12: Register that stores the starting address of matrix B in BRAM B.
//See detailed note on the usage of this register in REG_MATRIX_A_ADDR.
//---------------------------------------
`define REG_MATRIX_B_ADDR 32'h12
//Bit `AWIDTH-1:0 address_mat_b

//---------------------------------------
//Addr 16: Register that stores the starting address of matrix C in BRAM C.
//See detailed note on the usage of this register in REG_MATRIX_A_ADDR.
//---------------------------------------
`define REG_MATRIX_C_ADDR 32'h16
//Bit `AWIDTH-1:0 address_mat_c



//---------------------------------------
//Addr 24: Register that controls the accumulation logic
//---------------------------------------
`define REG_ACCUM_ACTIONS_ADDR 32'h24
//Bit 0 save_output_to_accumulator
//Bit 1 add_accumulator_to_output

//---------------------------------------
//(Only applicable in fully-connected mode)
//Addr 28: Register that stores the stride that should be taken to address
//elements in matrix A, after every MAT_MUL_SIZE worth of data has been fetched.
//See the diagram in "Meeting-16" notes in the EE382V project Onenote notebook.
//This stride is applied when incrementing addresses for matrix A in the vertical
//direction.
//---------------------------------------
`define REG_MATRIX_A_STRIDE_ADDR 32'h28
//Bit `ADDR_STRIDE_WIDTH-1:0 address_stride_a

//---------------------------------------
//(Only applicable in fully-connected mode)
//Addr 32: Register that stores the stride that should be taken to address
//elements in matrix B, after every MAT_MUL_SIZE worth of data has been fetched.
//See the diagram in "Meeting-16" notes in the EE382V project Onenote notebook.
//This stride is applied when incrementing addresses for matrix B in the horizontal
//direction.
//---------------------------------------
`define REG_MATRIX_B_STRIDE_ADDR 32'h32
//Bit `ADDR_STRIDE_WIDTH-1:0 address_stride_b

//---------------------------------------
//(Only applicable in fully-connected mode)
//Addr 36: Register that stores the stride that should be taken to address
//elements in matrix C, after every MAT_MUL_SIZE worth of data has been fetched.
//See the diagram in "Meeting-16" notes in the EE382V project Onenote notebook.
//This stride is applied when incrementing addresses for matrix C in the vertical
//direction (this is generally same as address_stride_a).
//---------------------------------------
`define REG_MATRIX_C_STRIDE_ADDR 32'h36
//Bit `ADDR_STRIDE_WIDTH-1:0 address_stride_c

//---------------------------------------
//Addr 3A: Register that controls the activation block. Currently, the available 
//settings are the selector of activation function that will be used. There are
//two options: ReLU and TanH. To use ReLU, clear the LSB of this register. To
//use TanH, set the LSB of this register.
//---------------------------------------
`define REG_ACTIVATION_CSR_ADDR 32'h3A

//---------------------------------------
//Addr 3E: Register defining pooling window size
//---------------------------------------
`define REG_POOL_WINDOW_ADDR 32'h3E
//Bit `MAX_BITS_POOL-1:0 pool window size

//---------------------------------------
//Addr 40: Register defining convolution parameters - 1
//----------------------------------------
`define REG_CONV_PARAMS_1_ADDR 32'h40
//Bits filter_height (R) 3:0
//Bits filter width (S)  7:4
//Bits stride_horizontal 11:8
//Bits stride_vertical 15:12
//Bits pad_left 19:16
//Bits pad_right 23:20
//Bits pad_top 27:24
//Bits pad_bottom 31:28

//---------------------------------------
//Addr 44: Register defining convolution parameters - 2
//----------------------------------------
`define REG_CONV_PARAMS_2_ADDR 32'h44
//Bits num_channels_input (C) 15:0
//Bits num_channels_output (K) 31:16

//---------------------------------------
//Addr 48: Register defining convolution parameters - 3
//----------------------------------------
`define REG_CONV_PARAMS_3_ADDR 32'h48
//Bits input_image_height (H) 15:0
//Bits input_image_width (W) 31:16

//---------------------------------------
//Addr 4C: Register defining convolution parameters - 4
//----------------------------------------
`define REG_CONV_PARAMS_4_ADDR 32'h4C
//Bits output_image_height (P) 15:0
//Bits output_image_width (Q) 31:16

//---------------------------------------
//Addr 50: Register defining batch size
//----------------------------------------
`define REG_BATCH_SIZE_ADDR 32'h50
//Bits 31:0 batch_size (number of images, N)

//---------------------------------------
//Addresses 54,58,5C: Registers that stores the mask of which parts of the matrices are valid.
//
//Some examples where this is useful:
//1. Input matrix is smaller than the matmul. 
//   Say we want to multiply a 6x6 using an 8x8 matmul.
//   The matmul still operates on the whole 8x8 part, so we need
//   to ensure that there are 0s in the BRAMs in the invalid parts.
//   But the mask is used by the blocks other than matmul. For ex,
//   norm block will use the mask to avoid applying mean and variance 
//   to invalid parts (so tha they stay 0). 
//2. When we start with large matrices, the size of the matrices can
//   reduce to something less than the matmul size because of pooling.
//   In that case for the next layer, we need to tell blocks like norm,
//   what is valid and what is not.
//
//Note: This masks is applied to both x and y directions and also
//applied to both input matrices - A and B.
//---------------------------------------
`define REG_VALID_MASK_A_ROWS_ADDR 32'h20
`define REG_VALID_MASK_A_COLS_B_ROWS_ADDR 32'h54
`define REG_VALID_MASK_B_COLS_ADDR 32'h58
//Bit `MASK_WIDTH-1:0 validity_mask


//////////////////////////

//../design_composed/16x16_from_8x8.int8.no_ram.gen.for_combined_matmul.v 

//////////////////////////


`timescale 1ns/1ns
`define DWIDTH 8
`define AWIDTH 10
`define MEM_SIZE 1024
`define DESIGN_SIZE 16
`define MAT_MUL_SIZE 8
`define MASK_WIDTH 8
`define LOG2_MAT_MUL_SIZE 3
`define NUM_CYCLES_IN_MAC 3
`define MEM_ACCESS_LATENCY 1
`define REG_DATAWIDTH 32
`define REG_ADDRWIDTH 8
`define ADDR_STRIDE_WIDTH 16
`define REG_STDN_TPU_ADDR 32'h4
`define REG_MATRIX_A_ADDR 32'he
`define REG_MATRIX_B_ADDR 32'h12
`define REG_MATRIX_C_ADDR 32'h16
`define REG_VALID_MASK_A_ROWS_ADDR 32'h20
`define REG_VALID_MASK_A_COLS_B_ROWS_ADDR 32'h54
`define REG_VALID_MASK_B_COLS_ADDR 32'h58
`define REG_MATRIX_A_STRIDE_ADDR 32'h28
`define REG_MATRIX_B_STRIDE_ADDR 32'h32
`define REG_MATRIX_C_STRIDE_ADDR 32'h36
  
/////////////////////////////////////////////////
// The 16x16 matmul definition
/////////////////////////////////////////////////


module matmul_16x16_systolic_composed_from_8x8(
  input clk,
  input reset,
  input pe_reset,
  input start_mat_mul,
  output done_mat_mul,

  input [`AWIDTH-1:0] address_mat_a,
  input [`AWIDTH-1:0] address_mat_b,
  input [`AWIDTH-1:0] address_mat_c,
  input [`ADDR_STRIDE_WIDTH-1:0] address_stride_a,
  input [`ADDR_STRIDE_WIDTH-1:0] address_stride_b,
  input [`ADDR_STRIDE_WIDTH-1:0] address_stride_c,
  
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0,
  output [`AWIDTH-1:0] a_addr_0_0,
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0,
  output [`AWIDTH-1:0] b_addr_0_0,
  
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0,
  output [`AWIDTH-1:0] a_addr_1_0,
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1,
  output [`AWIDTH-1:0] b_addr_0_1,
  
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_1,
  output [`AWIDTH-1:0] c_addr_0_1,
  output c_data_0_1_available,
    
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_1,
  output [`AWIDTH-1:0] c_addr_1_1,
  output c_data_1_1_available,
    
  input [`MASK_WIDTH-1:0] validity_mask_a_rows,
  input [`MASK_WIDTH-1:0] validity_mask_a_cols_b_rows,
  input [`MASK_WIDTH-1:0] validity_mask_b_cols
);
    /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_0_0;
  wire done_mat_mul_0_1;
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;

  assign done_mat_mul = done_mat_mul_0_0 || done_mat_mul_0_1 || done_mat_mul_1_0 || done_mat_mul_1_1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_1_NC;
    
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_1_NC;
      /////////////////////////////////////////////////
  // Matmul 0_0
  /////////////////////////////////////////////////

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_to_0_1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_to_1_0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_0_0_NC;
  assign a_data_in_0_0_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_in_0_0_NC;
  assign c_data_in_0_0_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_0_NC;
  assign b_data_in_0_0_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0_to_0_1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0_to_0_1_NC;
  wire [`AWIDTH-1:0] c_addr_0_0_NC;
  wire c_data_0_0_available_NC;

matmul_int8 u_matmul_8x8_systolic_0_0(
  .clk(clk),
  .reset(reset),
  .pe_reset(pe_reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_0),
  .address_mat_a(address_mat_a),
  .address_mat_b(address_mat_b),
  .address_mat_c(address_mat_c),
  .address_stride_a(address_stride_a),
  .address_stride_b(address_stride_b),
  .address_stride_c(address_stride_c),
  .a_data(a_data_0_0),
  .b_data(b_data_0_0),
  .a_data_in(a_data_in_0_0_NC),
  .b_data_in(b_data_in_0_0_NC),
  .c_data_in(c_data_in_0_0_NC),
  .c_data_out(c_data_0_0_to_0_1),
  .c_data_out_dir_int(c_data_0_0_to_0_1_NC),
  .a_data_out(a_data_0_0_to_0_1),
  .b_data_out(b_data_0_0_to_1_0),
  .a_addr(a_addr_0_0),
  .b_addr(b_addr_0_0),
  .c_addr(c_addr_0_0_NC),
  .c_data_available(c_data_0_0_available_NC),

  .validity_mask_a_rows(validity_mask_a_rows),
  .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
  .validity_mask_b_cols(validity_mask_b_cols),
        
  .slice_mode(1'b0), //0 is SLICE_MODE_MATMUL
  .slice_dtype(1'b0), //0 is INT8      
        
  .final_mat_mul_size(8'd16),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 0_1
  /////////////////////////////////////////////////

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_1_to_0_2;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1_to_1_1;
  wire [`AWIDTH-1:0] a_addr_0_1_NC;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_1_NC;
  assign a_data_0_1_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_1_NC;
  assign b_data_in_0_1_NC = 0;

matmul_int8 u_matmul_8x8_systolic_0_1(
  .clk(clk),
  .reset(reset),
  .pe_reset(pe_reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_1),
  .address_mat_a(address_mat_a),
  .address_mat_b(address_mat_b),
  .address_mat_c(address_mat_c),
  .address_stride_a(address_stride_a),
  .address_stride_b(address_stride_b),
  .address_stride_c(address_stride_c),
  .a_data(a_data_0_1_NC),
  .b_data(b_data_0_1),
  .a_data_in(a_data_0_0_to_0_1),
  .b_data_in(b_data_in_0_1_NC),
  .c_data_in(c_data_0_0_to_0_1),
  .c_data_out(c_data_0_1),
  .c_data_out_dir_int(c_data_0_1_NC),
  .a_data_out(a_data_0_1_to_0_2),
  .b_data_out(b_data_0_1_to_1_1),
  .a_addr(a_addr_0_1_NC),
  .b_addr(b_addr_0_1),
  .c_addr(c_addr_0_1),
  .c_data_available(c_data_0_1_available),

  .validity_mask_a_rows(validity_mask_a_rows),
  .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
  .validity_mask_b_cols(validity_mask_b_cols),
        
  .slice_mode(1'b0), //0 is SLICE_MODE_MATMUL
  .slice_dtype(1'b0), //0 is INT8      
        
  .final_mat_mul_size(8'd16),
  .a_loc(8'd0),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 1_0
  /////////////////////////////////////////////////

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0_to_1_1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_0_to_2_0;
  wire [`AWIDTH-1:0] b_addr_1_0_NC;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_0_NC;
  assign b_data_1_0_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_1_0_NC;
  assign a_data_in_1_0_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_in_1_0_NC;
  assign c_data_in_1_0_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_0_to_1_1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_0_to_1_1_NC;
  wire [`AWIDTH-1:0] c_addr_1_0_NC;
  wire c_data_1_0_available_NC;

matmul_int8 u_matmul_8x8_systolic_1_0(
  .clk(clk),
  .reset(reset),
  .pe_reset(pe_reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_0),
  .address_mat_a(address_mat_a),
  .address_mat_b(address_mat_b),
  .address_mat_c(address_mat_c),
  .address_stride_a(address_stride_a),
  .address_stride_b(address_stride_b),
  .address_stride_c(address_stride_c),
  .a_data(a_data_1_0),
  .b_data(b_data_1_0_NC),
  .a_data_in(a_data_in_1_0_NC),
  .b_data_in(b_data_0_0_to_1_0),
  .c_data_in(c_data_in_1_0_NC),
  .c_data_out(c_data_1_0_to_1_1),
  .c_data_out_dir_int(c_data_1_0_to_1_1_NC),
  .a_data_out(a_data_1_0_to_1_1),
  .b_data_out(b_data_1_0_to_2_0),
  .a_addr(a_addr_1_0),
  .b_addr(b_addr_1_0_NC),
  .c_addr(c_addr_1_0_NC),
  .c_data_available(c_data_1_0_available_NC),

  .validity_mask_a_rows(validity_mask_a_rows),
  .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
  .validity_mask_b_cols(validity_mask_b_cols),
        
  .slice_mode(1'b0), //0 is SLICE_MODE_MATMUL
  .slice_dtype(1'b0), //0 is INT8      
        
  .final_mat_mul_size(8'd16),
  .a_loc(8'd1),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 1_1
  /////////////////////////////////////////////////

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_1_to_1_2;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_1_to_2_1;
  wire [`AWIDTH-1:0] a_addr_1_1_NC;
  wire [`AWIDTH-1:0] b_addr_1_1_NC;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_1_NC;
  assign a_data_1_1_NC = 0;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_1_NC;
  assign b_data_1_1_NC = 0;

matmul_int8 u_matmul_8x8_systolic_1_1(
  .clk(clk),
  .reset(reset),
  .pe_reset(pe_reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_1),
  .address_mat_a(address_mat_a),
  .address_mat_b(address_mat_b),
  .address_mat_c(address_mat_c),
  .address_stride_a(address_stride_a),
  .address_stride_b(address_stride_b),
  .address_stride_c(address_stride_c),
  .a_data(a_data_1_1_NC),
  .b_data(b_data_1_1_NC),
  .a_data_in(a_data_1_0_to_1_1),
  .b_data_in(b_data_0_1_to_1_1),
  .c_data_in(c_data_1_0_to_1_1),
  .c_data_out(c_data_1_1),
  .c_data_out_dir_int(c_data_1_1_NC),
  .a_data_out(a_data_1_1_to_1_2),
  .b_data_out(b_data_1_1_to_2_1),
  .a_addr(a_addr_1_1_NC),
  .b_addr(b_addr_1_1_NC),
  .c_addr(c_addr_1_1),
  .c_data_available(c_data_1_1_available),

  .validity_mask_a_rows(validity_mask_a_rows),
  .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
  .validity_mask_b_cols(validity_mask_b_cols),
        
  .slice_mode(1'b0), //0 is SLICE_MODE_MATMUL
  .slice_dtype(1'b0), //0 is INT8      
        
  .final_mat_mul_size(8'd16),
  .a_loc(8'd1),
  .b_loc(8'd1)
);

endmodule

  


//////////////////////////

//../design_composed/16x16_from_8x8.wrap.v 

//////////////////////////

module matmul_16x16_systolic(
 clk,
 reset,
 pe_reset,
 start_mat_mul,
 done_mat_mul,
 address_mat_a,
 address_mat_b,
 address_mat_c,
 address_stride_a,
 address_stride_b,
 address_stride_c,
 a_data,
 b_data,
 a_data_in, //Data values coming in from previous matmul - systolic connections
 b_data_in,
 c_data_in, //Data values coming in from previous matmul - systolic shifting
 c_data_out, //Data values going out to next matmul - systolic shifting
 a_data_out,
 b_data_out,
 a_addr,
 b_addr,
 c_addr,
 c_data_available,

 validity_mask_a_rows,
 validity_mask_a_cols_b_rows,
 validity_mask_b_cols,
  
final_mat_mul_size,
  
 a_loc,
 b_loc
);

 input clk;
 input reset;
 input pe_reset;
 input start_mat_mul;
 output done_mat_mul;
 input [`AWIDTH-1:0] address_mat_a;
 input [`AWIDTH-1:0] address_mat_b;
 input [`AWIDTH-1:0] address_mat_c;
 input [`ADDR_STRIDE_WIDTH-1:0] address_stride_a;
 input [`ADDR_STRIDE_WIDTH-1:0] address_stride_b;
 input [`ADDR_STRIDE_WIDTH-1:0] address_stride_c;
 input [`DESIGN_SIZE*`DWIDTH-1:0] a_data;
 input [`DESIGN_SIZE*`DWIDTH-1:0] b_data;
 input [`DESIGN_SIZE*`DWIDTH-1:0] a_data_in;
 input [`DESIGN_SIZE*`DWIDTH-1:0] b_data_in;
 input [`DESIGN_SIZE*`DWIDTH-1:0] c_data_in;
 output [`DESIGN_SIZE*`DWIDTH-1:0] c_data_out;
 output [`DESIGN_SIZE*`DWIDTH-1:0] a_data_out;
 output [`DESIGN_SIZE*`DWIDTH-1:0] b_data_out;
 output [`AWIDTH-1:0] a_addr;
 output [`AWIDTH-1:0] b_addr;
 output [`AWIDTH-1:0] c_addr;
 output c_data_available;

 input [`MASK_WIDTH-1:0] validity_mask_a_rows;
 input [`MASK_WIDTH-1:0] validity_mask_a_cols_b_rows;
 input [`MASK_WIDTH-1:0] validity_mask_b_cols;

//7:0 is okay here. We aren't going to make a matmul larger than 128x128
//In fact, these will get optimized out by the synthesis tool, because
//we hardcode them at the instantiation level.
 input [7:0] final_mat_mul_size;
  
 input [7:0] a_loc;
 input [7:0] b_loc;

 wire [`DESIGN_SIZE*`DWIDTH-1:0] a_data_in_NC;
 wire [`DESIGN_SIZE*`DWIDTH-1:0] b_data_in_NC;
 wire [`DESIGN_SIZE*`DWIDTH-1:0] c_data_in_NC;
 assign a_data_in_NC = a_data_in;
 assign b_data_in_NC = b_data_in;
 assign c_data_in_NC = c_data_in;
 wire [7:0] final_mat_mul_size_NC;
 wire [7:0] a_loc_NC;
 wire [7:0] b_loc_NC;
 assign final_mat_mul_size_NC = final_mat_mul_size;
 assign a_loc_NC = a_loc;
 assign b_loc_NC = b_loc;


 	wire [`AWIDTH-1:0] bram_addr_a_0_0;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_a_0_0;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_a_0_0;
	wire [`DESIGN_SIZE-1:0] bram_we_a_0_0;
	wire bram_en_a_0_0;
    
	wire [`AWIDTH-1:0] bram_addr_a_1_0;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_a_1_0;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_a_1_0;
	wire [`DESIGN_SIZE-1:0] bram_we_a_1_0;
	wire bram_en_a_1_0;
    
	wire [`AWIDTH-1:0] bram_addr_b_0_0;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_b_0_0;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_b_0_0;
	wire [`DESIGN_SIZE-1:0] bram_we_b_0_0;
	wire bram_en_b_0_0;
    
	wire [`AWIDTH-1:0] bram_addr_b_0_1;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_b_0_1;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_b_0_1;
	wire [`DESIGN_SIZE-1:0] bram_we_b_0_1;
	wire bram_en_b_0_1;
    
	wire [`AWIDTH-1:0] bram_addr_c_0_1;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_c_0_1;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_c_0_1;
	wire [`DESIGN_SIZE-1:0] bram_we_c_0_1;
	wire bram_en_c_0_1;
    
	wire [`AWIDTH-1:0] bram_addr_c_1_1;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_c_1_1;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_c_1_1;
	wire [`DESIGN_SIZE-1:0] bram_we_c_1_1;
	wire bram_en_c_1_1;

    wire c_data_0_1_available;
    wire c_data_1_1_available;

    assign a_addr = bram_addr_a_0_0 | bram_addr_a_1_0; //fake OR to avoid ODIN optimization
    assign b_addr = bram_addr_b_0_0 | bram_addr_b_0_1; //fake OR to avoid ODIN optimization

	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_1;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_2;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_3;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_4;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_5;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_6;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_7;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_delayed_8;

    assign bram_rdata_a_0_0 = a_data[`MAT_MUL_SIZE*`DWIDTH-1:0];
    assign bram_rdata_a_1_0 = a_data_delayed_8;

    always @(posedge clk) begin
        if (reset) begin
            a_data_delayed_1 <= 0; 
            a_data_delayed_2 <= 0; 
            a_data_delayed_3 <= 0; 
            a_data_delayed_4 <= 0; 
            a_data_delayed_5 <= 0; 
            a_data_delayed_6 <= 0; 
            a_data_delayed_7 <= 0; 
            a_data_delayed_8 <= 0; 
        end
        else begin
            a_data_delayed_1 <= a_data[2*`MAT_MUL_SIZE*`DWIDTH-1:`MAT_MUL_SIZE*`DWIDTH];
            a_data_delayed_2 <= a_data_delayed_1;
            a_data_delayed_3 <= a_data_delayed_2;
            a_data_delayed_4 <= a_data_delayed_3;
            a_data_delayed_5 <= a_data_delayed_4;
            a_data_delayed_6 <= a_data_delayed_5;
            a_data_delayed_7 <= a_data_delayed_6;
            a_data_delayed_8 <= a_data_delayed_7;
        end
    end

	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_1;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_2;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_3;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_4;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_5;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_6;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_7;
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_delayed_8;

    assign bram_rdata_b_0_0 = b_data[`MAT_MUL_SIZE*`DWIDTH-1:0];
    assign bram_rdata_b_0_1 = b_data_delayed_8;

    always @(posedge clk) begin
        if (reset) begin
            b_data_delayed_1 <= 0; 
            b_data_delayed_2 <= 0; 
            b_data_delayed_3 <= 0; 
            b_data_delayed_4 <= 0; 
            b_data_delayed_5 <= 0; 
            b_data_delayed_6 <= 0; 
            b_data_delayed_7 <= 0; 
            b_data_delayed_8 <= 0; 
        end
        else begin
            b_data_delayed_1 <= b_data[2*`MAT_MUL_SIZE*`DWIDTH-1:`MAT_MUL_SIZE*`DWIDTH];
            b_data_delayed_2 <= b_data_delayed_1;
            b_data_delayed_3 <= b_data_delayed_2;
            b_data_delayed_4 <= b_data_delayed_3;
            b_data_delayed_5 <= b_data_delayed_4;
            b_data_delayed_6 <= b_data_delayed_5;
            b_data_delayed_7 <= b_data_delayed_6;
            b_data_delayed_8 <= b_data_delayed_7;
        end
    end

assign c_data_out = {bram_wdata_c_1_1, bram_wdata_c_0_1};
assign c_data_available = c_data_0_1_available | c_data_1_1_available; //fake ORing to prevent ODIN optimization
assign c_addr = bram_addr_c_0_1 | bram_addr_c_1_1; //fake ORing to prevent ODIN optimization

matmul_16x16_systolic_composed_from_8x8 u_matmul_16x16_systolic (
  .clk(clk),
  .reset(reset),
  .pe_reset(pe_reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
  .address_mat_a(address_mat_a),
  .address_mat_b(address_mat_b),
  .address_mat_c(address_mat_c),
  .address_stride_a(address_stride_a),
  .address_stride_b(address_stride_b),
  .address_stride_c(address_stride_c),
  
  .a_data_0_0(bram_rdata_a_0_0),
  .b_data_0_0(bram_rdata_b_0_0),
  .a_addr_0_0(bram_addr_a_0_0),
  .b_addr_0_0(bram_addr_b_0_0),
  	
  .a_data_1_0(bram_rdata_a_1_0),
  .b_data_0_1(bram_rdata_b_0_1),
  .a_addr_1_0(bram_addr_a_1_0),
  .b_addr_0_1(bram_addr_b_0_1),
  	
  .c_data_0_1(bram_wdata_c_0_1),
  .c_addr_0_1(bram_addr_c_0_1),
  .c_data_0_1_available(c_data_0_1_available),
   		
  .c_data_1_1(bram_wdata_c_1_1),
  .c_addr_1_1(bram_addr_c_1_1),
  .c_data_1_1_available(c_data_1_1_available),
   		
  .validity_mask_a_rows(validity_mask_a_rows),
  .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
  .validity_mask_b_cols(validity_mask_b_cols)
);

endmodule

