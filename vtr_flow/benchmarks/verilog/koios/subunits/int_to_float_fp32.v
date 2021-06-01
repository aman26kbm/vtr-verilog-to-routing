module int_to_float(
        input_a,
        clk,
        rst,
        output_z);

  input     clk;
  input     rst;

  input     [31:0] input_a;
  output    [31:0] output_z;

  
  reg [31:0] pipe_in;
  reg [64:0] pipe_1;
  reg [70:0] pipe_2;
  reg [70:0] pipe_3;
  reg [70:0] pipe_4;
  reg [64:0] pipe_5;
  reg [31:0] pipe_6;
  
  wire [31:0] value;
  wire z_s;
  wire [5:0] tmp_cnt;
  wire [5:0] sub_a_e;
  wire [5:0] sub_z_e;
  wire [31:0] a_m_shift;
  wire [23:0] z_m_final;
  wire [7:0] z_e_final;
  wire [31:0] z;
  
  align dut_align (pipe_in,value,z_s);
  lzc dut_lzc (pipe_1[31:0],tmp_cnt);
  sub dut_sub (pipe_2[38:33],sub_a_e);
  sub2 dut_sub2 (pipe_3[38:33],sub_z_e);
  am_shift dut_am_shift (pipe_3[31:0],pipe_3[38:33],a_m_shift);
  exception dut_exception (pipe_4[31:0],{2'b0,pipe_4[38:33]},z_m_final,z_e_final);
  final_out dut_final_out (pipe_5[64:33],pipe_5[23:0],pipe_5[31:24],pipe_5[32],z);
  
  always@(posedge clk) begin
	if (rst) begin
        pipe_in <= 32'h0;
		pipe_1 <= 65'h0;
		pipe_2 <= 71'h0;
		pipe_3 <= 71'h0;
		pipe_4 <= 71'h0;
		pipe_5 <= 65'h0;
		pipe_6 <= 31'h0;
	end
	else begin
        pipe_in <= input_a;
		pipe_1 <= {pipe_in,z_s,value};
		pipe_2 <= {pipe_1[64:33],tmp_cnt,pipe_1[32:0]};
		pipe_3 <= {pipe_2[70:39],sub_a_e,pipe_2[32:0]};
		pipe_4 <= {pipe_3[70:39],sub_z_e,pipe_3[32],a_m_shift};
		pipe_5 <= {pipe_4[70:39],pipe_4[32],z_e_final,z_m_final};
        pipe_6 <= z;
  end	
  end
  assign output_z = pipe_6;
  
endmodule

module align (
input [31:0] a,
output [31:0] value,
output z_s);


	assign value = a[31] ? -a : a;
    assign z_s = a[31];

endmodule

/*module align2 (
input [31:0] value,
output [31:0] z_m,
//output [7:0] z_r,
//output [7:0] z_e);


	//z_e <= 8'd31;
    z_m <= value[31:0];
    //z_r <= value[7:0];

endmodule*/

module lzc (
  input [31:0] z_m,
output reg [5:0] tmp_cnt_final);

wire [31:0] Sj_int;
  //wire [15:0] val32;
wire [15:0] val16;
wire [7:0] val8;
wire [3:0] val4;
wire [5:0] tmp_cnt;

assign Sj_int = z_m;
  
assign    tmp_cnt[5] = 1'b0;
assign    tmp_cnt[4] = (Sj_int[31:16] == 16'b0);
assign    val16 = tmp_cnt[4] ? Sj_int[15:0] : Sj_int[31:16];
assign    tmp_cnt[3] = (val16[15:8] == 8'b0);
assign    val8 = tmp_cnt[3] ? val16[7:0] : val16 [15:8];
assign    tmp_cnt[2] = (val8[7:4] == 4'b0);
assign    val4 = tmp_cnt[2] ? val8[3:0] : val8[7:4];
assign    tmp_cnt[1] = (val4[3:2] == 2'b0);
assign    tmp_cnt[0] = tmp_cnt[1] ? ~val4[1] : ~val4[3];

always@(Sj_int or tmp_cnt)
begin
if (Sj_int[31:0] == 32'b0)
   tmp_cnt_final = 6'd32;
else
   begin
   tmp_cnt_final = tmp_cnt;
end
end
endmodule

module sub (
input [5:0] a_e,
  output [5:0] sub_a_e);

assign sub_a_e = a_e;

endmodule

module sub2 (
input [5:0] a_e,
  output [5:0] sub_a_e);

assign sub_a_e = 31 - a_e;

endmodule

module am_shift (
input [31:0] a_m,
input [5:0] tmp_cnt,
output [31:0] a_m_shift);

assign a_m_shift = a_m << tmp_cnt;  
endmodule

module exception (
input [31:0] a_m_shift,
input [7:0] z_e,
output reg [23:0] z_m_final,
output reg [7:0] z_e_final
);

wire guard;
wire round_bit;
wire sticky;
wire [23:0] z_m;

assign guard = a_m_shift[7];
assign round_bit = a_m_shift[6];
assign sticky = a_m_shift[5:0] != 0;

assign z_m = a_m_shift[31:8];

always@(guard or round_bit or sticky or z_m or z_e)
begin
if (guard && (round_bit || sticky || z_m[0])) begin
    z_m_final = z_m + 1;
          if (z_m == 24'hffffff) begin
            z_e_final = z_e + 1;
          end
		  else z_e_final = z_e;
          end
else begin 
  z_m_final = z_m;
  z_e_final = z_e;
end
end
endmodule

module final_out (
input [31:0] a,
input [23:0] z_m,
input [7:0] z_e,
input z_s,
output reg [31:0] output_z);

  always@(a or z_m or z_e or z_s) begin
	if (a == 32'b0) begin
		output_z = 32'b0;
	end
	else begin
		output_z[22:0] = z_m[22:0];
      output_z[30:23] = z_e + 8'd127;
		output_z[31] = z_s;
	end
  end

endmodule
