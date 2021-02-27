module float_to_int(
        input_a,
        clk,
        rst,
        output_z);

  input     clk;
  input     rst;

  input     [31:0] input_a;
  output    [31:0] output_z;

  
  wire [31:0] z;
  wire [8:0] a_e, sub_a_e;
  wire a_s;
  wire [31:0] a_m;
  wire [31:0] a_m_shift;
  wire [31:0] temp_z;
  
  reg [31:0] pipe_in;
  reg [41:0] pipe_1;
  reg [50:0] pipe_2;
  reg [50:0] pipe_3;
  reg [40:0] pipe_4;
  reg [31:0] pipe_5;
  reg [31:0] pipe_6;
  
  
  align_ftoi dut_align (pipe_in,a_m,a_e,a_s);
  sub_ftoi dut_sub (pipe_1[40:32],sub_a_e);
  am_shift_ftoi dut_am_shift (pipe_2[40:32],pipe_2[50:42],pipe_2[31:0],a_m_shift);
  two_comp_ftoi dut_two_comp (pipe_3[50:19], pipe_3[9],z);
  final_out_ftoi dut_final_out (pipe_4[40:9], pipe_4[8:0], temp_z);
  
  always@(posedge clk) begin
	if (rst) begin
        pipe_in <= 32'h0;
		pipe_1 <= 42'h0;
		pipe_2 <= 51'h0;
		pipe_3 <= 51'h0;
		pipe_4 <= 41'h0;
		pipe_5 <= 32'h0;
		pipe_6 <= 32'h0;
	end
	else begin
        pipe_in <= input_a;
		pipe_1 <= {a_s,a_e,a_m};
		pipe_2 <= {sub_a_e,pipe_1};
		pipe_3 <= {a_m_shift,pipe_2[50:32]};
		pipe_4 <= {z,pipe_3[8:0]};
		pipe_5 <= temp_z;
        pipe_6 <= pipe_5;
  end	
  end
  assign output_z = pipe_6;
  
endmodule

module align_ftoi (
input [31:0] input_a,
output [31:0] a_m,
output [8:0] a_e,
output a_s);

wire [31:0] a;

  assign a = input_a;
  assign a_m[31:8] = {1'b1, a[22 : 0]};
  assign a_m[7:0] = 8'b0;
  assign a_e = a[30 : 23] - 127;
  assign a_s = a[31];

endmodule

module sub_ftoi (
input [8:0] a_e,
  output [8:0] sub_a_e);

assign sub_a_e = 31 - a_e;

endmodule

module am_shift_ftoi (
input [8:0] a_e,
input [8:0] sub_a_e,
input [31:0] a_m,
  output reg [31:0] a_m_shift);

always@(a_e or sub_a_e or a_m) begin
    if ((a_e) <= 31 && (a_e) >= 0 ) begin
		a_m_shift = a_m >> sub_a_e;
	end
	else begin
		a_m_shift = 32'h0;
	end
  end
  
endmodule

module two_comp_ftoi (
input [31:0] a_m_shift,
input a_s,
  output [31:0] z);

assign z = a_s ? -a_m_shift : a_m_shift; // 2's complement

endmodule

module final_out_ftoi (
input [31:0] z,
  input [8:0] a_e,
  output reg [31:0] output_z);

always@(a_e or z) begin
	if (a_e[8] == 1'b1 && a_e[7:0] == 8'd127) begin
		output_z = 32'b0;
	end
	else if (a_e[8] == 0 && a_e[7:0] > 8'd31) begin
		output_z = 32'hFFFFFFFF;
	end
	else begin
		output_z = z;
	end
  end

endmodule
