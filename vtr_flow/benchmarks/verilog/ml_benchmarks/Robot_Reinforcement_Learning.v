`timescale 1 ns / 1 ns

// To do: make it VTR compatible

////////////////////////////////////////////////////////////////////////////////////////
/*
Author: Samidh Mehta
Reinforcement Learning benchmark
Problem statement: There are 6 regions on a board. The robot has to reach Region 6.
Q learning accelerator generated using HDL coder (Simulink / MATLAB)
4 actions
6 states

The design consists of 2 policy generators. 
A random number generator is used as a ploicy generator during training .(mode = 0)
A policy generator where the action is based on the Maximum value of Q is used during inference. (mode = 1)


Misc: 
ufix6_En4 : 6 bit fixed point number --> 2 bits for integer, 4 bits for the fractional part.
alpha = gamma = 0.5

*/
////////////////////////////////////////////////////////////////////////////////////////


// Sum_Calc: Calculates the value of the Q expression after accomodating for the different radix forms of the numbers. 
module Sum_Calc
          (Q,
           alpha,
           r,
           gamma,
           max,
           Output_rsvd);


  input   signed [31:0] Q;  // int32
  input   [7:0] alpha;  // ufix8_En7
  input   signed [31:0] r;  // sfix32_En4
  input   [7:0] gamma;  // ufix8_En7
  input   signed [15:0] max;  // int16
  output  signed [31:0] Output_rsvd;  // int32


  wire signed [37:0] Sum1_stage2_sub_cast;  // sfix38_En4
  wire signed [37:0] Sum1_stage2_sub_cast_1;  // sfix38_En4
  wire signed [37:0] Sum1_op_stage2;  // sfix38_En4
  wire signed [8:0] Product_cast;  // sfix9_En7
  wire signed [24:0] Product_mul_temp;  // sfix25_En7
  wire signed [23:0] Product_cast_1;  // sfix24_En7
  wire signed [31:0] Product_out1;  // int32
  wire signed [37:0] Sum1_stage3_add_cast;  // sfix38_En4
  wire signed [37:0] Sum1_stage3_add_temp;  // sfix38_En4
  wire signed [31:0] Sum1_out1;  // int32
  wire signed [8:0] Product1_cast;  // sfix9_En7
  wire signed [40:0] Product1_mul_temp;  // sfix41_En7
  wire signed [39:0] Product1_cast_1;  // sfix40_En7
  wire signed [31:0] Product1_out1;  // int32
  wire signed [15:0] Sum_add_cast;  // sfix16
  wire signed [15:0] Sum_add_cast_1;  // sfix16
  wire signed [15:0] Sum_add_temp;  // sfix16
  wire signed [31:0] Sum_out1;  // int32


  assign Sum1_stage2_sub_cast = {{6{r[31]}}, r};
  assign Sum1_stage2_sub_cast_1 = {{2{Q[31]}}, {Q, 4'b0000}};
  assign Sum1_op_stage2 = Sum1_stage2_sub_cast - Sum1_stage2_sub_cast_1;



  assign Product_cast = {1'b0, gamma};
  assign Product_mul_temp = max * Product_cast;
  assign Product_cast_1 = Product_mul_temp[23:0];
  assign Product_out1 = {{15{Product_cast_1[23]}}, Product_cast_1[23:7]};



  assign Sum1_stage3_add_cast = {{2{Product_out1[31]}}, {Product_out1, 4'b0000}};
  assign Sum1_stage3_add_temp = Sum1_op_stage2 + Sum1_stage3_add_cast;
  assign Sum1_out1 = Sum1_stage3_add_temp[35:4];



  assign Product1_cast = {1'b0, alpha};
  assign Product1_mul_temp = Sum1_out1 * Product1_cast;
  assign Product1_cast_1 = Product1_mul_temp[39:0];
  assign Product1_out1 = Product1_cast_1[38:7];



  assign Sum_add_cast = Q[15:0];
  assign Sum_add_cast_1 = Product1_out1[15:0];
  assign Sum_add_temp = Sum_add_cast + Sum_add_cast_1;
  assign Sum_out1 = {{16{Sum_add_temp[15]}}, Sum_add_temp};

  assign Output_rsvd = Sum_out1;

endmodule  // Sum_Calc

//Max: Gives an output of the maximum number from 4 possible numbers (= no. of actions) truncated to fit within 16 bits.
// A tree approach is used, where 3 comparators are used. 
module Max
          (in0_0,
           in0_1,
           in0_2,
           in0_3,
           out0);


  input   signed [31:0] in0_0;  // int32
  input   signed [31:0] in0_1;  // int32
  input   signed [31:0] in0_2;  // int32
  input   signed [31:0] in0_3;  // int32
  output  signed [15:0] out0;  // int16


  wire signed [31:0] in0 [0:3];  // int32 [4]
  wire signed [31:0] Max_stage1_val [0:1];  // int32 [2]
  wire signed [31:0] Max_stage2_val;  // int32


  assign in0[0] = in0_0;
  assign in0[1] = in0_1;
  assign in0[2] = in0_2;
  assign in0[3] = in0_3;

  // ---- Tree max implementation ----
  // ---- Tree max stage 1 ----
  assign Max_stage1_val[0] = (in0[0] >= in0[1] ? in0[0] :
              in0[1]);
  assign Max_stage1_val[1] = (in0[2] >= in0[3] ? in0[2] :
              in0[3]);



  // ---- Tree max stage 2 ----
  assign Max_stage2_val = (Max_stage1_val[0] >= Max_stage1_val[1] ? Max_stage1_val[0] :
              Max_stage1_val[1]);



  assign out0 = Max_stage2_val[15:0];



endmodule  // Max

// SimpleDualPortRAM_generic : 4 RAM banks ( = no. of actions) with a depth of 6 ( = no. of states). Writes during training. Reads during inferfence.
module SimpleDualPortRAM_generic
          (clk,
           enb,
           wr_din,
           wr_addr,
           wr_en,
           rd_addr,
           rd_dout);

  parameter AddrWidth = 1;
  parameter DataWidth = 1;

  input   clk;
  input   enb;
  input   signed [DataWidth - 1:0] wr_din;  // parameterized width
  input   [AddrWidth - 1:0] wr_addr;  // parameterized width
  input   wr_en;  // ufix1
  input   [AddrWidth - 1:0] rd_addr;  // parameterized width
  output  signed [DataWidth - 1:0] rd_dout;  // parameterized width


  reg  [DataWidth - 1:0] ram [2**AddrWidth - 1:0];
  reg  [DataWidth - 1:0] data_int;
  integer i;

  initial begin
    ram[7] = 32'h00000000;
    ram[6] = 32'h00000000;
    ram[5] = 32'h00000000;
    ram[4] = 32'h00000000;
    ram[3] = 32'h00000000;
    ram[2] = 32'h00000000;
    ram[1] = 32'h00000000;
    ram[0] = 32'h00000000;

    data_int = 32'h00000000;
  end


  always @(posedge clk)
    begin : SimpleDualPortRAM_generic_process
      if (enb == 1'b1) begin
        if (wr_en == 1'b1) begin
          ram[wr_addr] <= wr_din;
        end
        data_int <= ram[rd_addr];
      end
    end

  assign rd_dout = data_int;

endmodule  // SimpleDualPortRAM_generic

// Q_Hw: connects all the blocks and incorporates pipelining for appropriate syncing. 
module Q_HW
          (mode, clk,
           reset,
           clk_enable,
           State,
           Action,
           Reward,
           alpha,
           gamma,
           ce_out,
           Q, 
	 Data_Type_Conversion_out1_0,
	Data_Type_Conversion_out1_1,
	Data_Type_Conversion_out1_2,
	Data_Type_Conversion_out1_3
	 );

	input mode;
  input   clk;
  input   reset;
  input   clk_enable;
  input   [2:0] State;  // ufix3
  input   [1:0] Action;  // ufix2
  input   signed [31:0] Reward;  // sfix32_En4
  input   [7:0] alpha;  // ufix8_En7
  input   [7:0] gamma;  // ufix8_En7
  output  ce_out;
  output  signed [31:0] Q;  // int32
 output signed [31:0] Data_Type_Conversion_out1_0;
output signed [31:0] Data_Type_Conversion_out1_1;
output signed [31:0] Data_Type_Conversion_out1_2;
output signed [31:0] Data_Type_Conversion_out1_3;
 


  wire enb;
  reg [1:0] Delay2_out1;  // ufix2
  reg [1:0] Delay5_out1;  // ufix2
  wire [7:0] Data_Type_Conversion1_out1;  // uint8
  reg [2:0] Delay1_out1;  // ufix3
  reg [2:0] Delay4_out1;  // ufix3
  wire Constant3_out1;
  reg [7:0] Delay11_out1;  // ufix8_En7
  reg [7:0] Delay13_out1;  // ufix8_En7
  reg signed [31:0] Delay3_out1;  // sfix32_En4
  reg signed [31:0] Delay6_out1;  // sfix32_En4
  reg [7:0] Delay12_out1;  // ufix8_En7
  reg [7:0] Delay7_out1;  // ufix8_En7
  wire signed [31:0] Data_Type_Conversion_out1 [0:3];  // int32 [4]
  wire signed [15:0] Max_out1;  // int16
  wire signed [31:0] Assignment_out1 [0:3];  // int32 [4]
  wire signed [31:0] pre_rd_out;  // int32
  wire signed [31:0] pre_rd_out_1;  // int32
  wire signed [31:0] pre_rd_out_2;  // int32
  wire signed [31:0] Delay_out1 [0:3];  // int32 [4]
  wire signed [31:0] From8_out1 [0:3];  // int32 [4]
  wire signed [31:0] Sum_Calc_out1;  // int32
  wire signed [31:0] pre_rd_out_3;  // int32
  wire signed [31:0] Simple_Dual_Port_RAM_System_out1 [0:3];  // int32 [4]
  reg signed [31:0] Delay_reg [0:3];  // sfix32 [4]
  wire signed [31:0] Delay_reg_next [0:3];  // sfix32 [4]
  wire signed [31:0] Multiport_Switch_out1;  // int32
  reg signed [31:0] Delay9_out1;  // int32


assign Data_Type_Conversion_out1_0 = Data_Type_Conversion_out1[0];
assign Data_Type_Conversion_out1_1 = Data_Type_Conversion_out1[1];
assign Data_Type_Conversion_out1_2 = Data_Type_Conversion_out1[2];
assign Data_Type_Conversion_out1_3 = Data_Type_Conversion_out1[3];

  assign enb = clk_enable;

  always @(posedge clk or posedge reset)
    begin : Delay2_process
      if (reset == 1'b1) begin
        Delay2_out1 <= 2'b00;
      end
      else begin
        if (enb) begin
          Delay2_out1 <= Action;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay5_process
      if (reset == 1'b1) begin
        Delay5_out1 <= 2'b00;
      end
      else begin
        if (enb) begin
          Delay5_out1 <= Delay2_out1;
        end
      end
    end



  assign Data_Type_Conversion1_out1 = {6'b0, Delay5_out1};



  always @(posedge clk or posedge reset)
    begin : Delay1_process
      if (reset == 1'b1) begin
        Delay1_out1 <= 3'b000;
      end
      else begin
        if (enb) begin
          Delay1_out1 <= State;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay4_process
      if (reset == 1'b1) begin
        Delay4_out1 <= 3'b000;
      end
      else begin
        if (enb) begin
          Delay4_out1 <= Delay1_out1;
        end
      end
    end



  assign Constant3_out1 = !mode;


  always @(posedge clk or posedge reset)
    begin : Delay11_process
      if (reset == 1'b1) begin
        Delay11_out1 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          Delay11_out1 <= alpha;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay13_process
      if (reset == 1'b1) begin
        Delay13_out1 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          Delay13_out1 <= Delay11_out1;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay3_process
      if (reset == 1'b1) begin
        Delay3_out1 <= 32'sb00000000000000000000000000000000;
      end
      else begin
        if (enb) begin
          Delay3_out1 <= Reward;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay6_process
      if (reset == 1'b1) begin
        Delay6_out1 <= 32'sb00000000000000000000000000000000;
      end
      else begin
        if (enb) begin
          Delay6_out1 <= Delay3_out1;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay12_process
      if (reset == 1'b1) begin
        Delay12_out1 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          Delay12_out1 <= gamma;
        end
      end
    end



  always @(posedge clk or posedge reset)
    begin : Delay7_process
      if (reset == 1'b1) begin
        Delay7_out1 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          Delay7_out1 <= Delay12_out1;
        end
      end
    end



  Max u_Max (.in0_0(Data_Type_Conversion_out1[0]),  // int32
             .in0_1(Data_Type_Conversion_out1[1]),  // int32
             .in0_2(Data_Type_Conversion_out1[2]),  // int32
             .in0_3(Data_Type_Conversion_out1[3]),  // int32
             .out0(Max_out1)  // int16
             );

  SimpleDualPortRAM_generic #(.AddrWidth(3),
                              .DataWidth(32)
                              )
                            u_Simple_Dual_Port_RAM_System_bank3 (.clk(clk),
                                                                 .enb(clk_enable),
                                                                 .wr_din(Assignment_out1[3]),
                                                                 .wr_addr(Delay4_out1),
                                                                 .wr_en(Constant3_out1),
                                                                 .rd_addr(Delay1_out1),
                                                                 .rd_dout(pre_rd_out)
                                                                 );

  SimpleDualPortRAM_generic #(.AddrWidth(3),
                              .DataWidth(32)
                              )
                            u_Simple_Dual_Port_RAM_System_bank2 (.clk(clk),
                                                                 .enb(clk_enable),
                                                                 .wr_din(Assignment_out1[2]),
                                                                 .wr_addr(Delay4_out1),
                                                                 .wr_en(Constant3_out1),
                                                                 .rd_addr(Delay1_out1),
                                                                 .rd_dout(pre_rd_out_1)
                                                                 );

  SimpleDualPortRAM_generic #(.AddrWidth(3),
                              .DataWidth(32)
                              )
                            u_Simple_Dual_Port_RAM_System_bank1 (.clk(clk),
                                                                 .enb(clk_enable),
                                                                 .wr_din(Assignment_out1[1]),
                                                                 .wr_addr(Delay4_out1),
                                                                 .wr_en(Constant3_out1),
                                                                 .rd_addr(Delay1_out1),
                                                                 .rd_dout(pre_rd_out_2)
                                                                 );

  assign From8_out1[0] = Delay_out1[0];
  assign From8_out1[1] = Delay_out1[1];
  assign From8_out1[2] = Delay_out1[2];
  assign From8_out1[3] = Delay_out1[3];

  assign Assignment_out1[0] = (Data_Type_Conversion1_out1 == 8'b00000000 ? Sum_Calc_out1 :
              From8_out1[0]);
  assign Assignment_out1[1] = (Data_Type_Conversion1_out1 == 8'b00000001 ? Sum_Calc_out1 :
              From8_out1[1]);
  assign Assignment_out1[2] = (Data_Type_Conversion1_out1 == 8'b00000010 ? Sum_Calc_out1 :
              From8_out1[2]);
  assign Assignment_out1[3] = (Data_Type_Conversion1_out1 == 8'b00000011 ? Sum_Calc_out1 :
              From8_out1[3]);



  SimpleDualPortRAM_generic #(.AddrWidth(3),
                              .DataWidth(32)
                              )
                            u_Simple_Dual_Port_RAM_System_bank0 (.clk(clk),
                                                                 .enb(clk_enable),
                                                                 .wr_din(Assignment_out1[0]),
                                                                 .wr_addr(Delay4_out1),
                                                                 .wr_en(Constant3_out1),
                                                                 .rd_addr(Delay1_out1),
                                                                 .rd_dout(pre_rd_out_3)
                                                                 );

  assign Simple_Dual_Port_RAM_System_out1[0] = pre_rd_out_3;
  assign Simple_Dual_Port_RAM_System_out1[1] = pre_rd_out_2;
  assign Simple_Dual_Port_RAM_System_out1[2] = pre_rd_out_1;
  assign Simple_Dual_Port_RAM_System_out1[3] = pre_rd_out;

  assign Data_Type_Conversion_out1[0] = Simple_Dual_Port_RAM_System_out1[0];
  assign Data_Type_Conversion_out1[1] = Simple_Dual_Port_RAM_System_out1[1];
  assign Data_Type_Conversion_out1[2] = Simple_Dual_Port_RAM_System_out1[2];
  assign Data_Type_Conversion_out1[3] = Simple_Dual_Port_RAM_System_out1[3];



  always @(posedge clk or posedge reset)
    begin : Delay_process
      if (reset == 1'b1) begin
        Delay_reg[0] <= 32'sb00000000000000000000000000000000;
        Delay_reg[1] <= 32'sb00000000000000000000000000000000;
        Delay_reg[2] <= 32'sb00000000000000000000000000000000;
        Delay_reg[3] <= 32'sb00000000000000000000000000000000;
      end
      else begin
        if (enb) begin
          Delay_reg[0] <= Delay_reg_next[0];
          Delay_reg[1] <= Delay_reg_next[1];
          Delay_reg[2] <= Delay_reg_next[2];
          Delay_reg[3] <= Delay_reg_next[3];
        end
      end
    end

  assign Delay_out1[0] = Delay_reg[0];
  assign Delay_out1[1] = Delay_reg[1];
  assign Delay_out1[2] = Delay_reg[2];
  assign Delay_out1[3] = Delay_reg[3];
  assign Delay_reg_next[0] = Data_Type_Conversion_out1[0];
  assign Delay_reg_next[1] = Data_Type_Conversion_out1[1];
  assign Delay_reg_next[2] = Data_Type_Conversion_out1[2];
  assign Delay_reg_next[3] = Data_Type_Conversion_out1[3];



  assign Multiport_Switch_out1 = (Delay5_out1 == 2'b00 ? Delay_out1[0] :
              (Delay5_out1 == 2'b01 ? Delay_out1[1] :
              (Delay5_out1 == 2'b10 ? Delay_out1[2] :
              Delay_out1[3])));



  Sum_Calc u_Sum_Calc (.Q(Multiport_Switch_out1),  // int32
                       .alpha(Delay13_out1),  // ufix8_En7
                       .r(Delay6_out1),  // sfix32_En4
                       .gamma(Delay7_out1),  // ufix8_En7
                       .max(Max_out1),  // int16
                       .Output_rsvd(Sum_Calc_out1)  // int32
                       );

  always @(posedge clk or posedge reset)
    begin : Delay9_process
      if (reset == 1'b1) begin
        Delay9_out1 <= 32'sb00000000000000000000000000000000;
      end
      else begin
        if (enb) begin
          Delay9_out1 <= Sum_Calc_out1;
        end
      end
    end


  assign Q = Delay9_out1;

  assign ce_out = clk_enable;

endmodule  // Q_HW


// FSM: Mealy state machine for the action-state relation. Reward values have been adjusted to suit the problem statement.
module FSM ( input clk, input reset, input [1:0] action, output reg signed [31:0] reward, output reg [2:0] state, output [1:0] next_action);

parameter 	region1 = 3'd0,
		region2 = 3'd1,
		region3 = 3'd2,
		region4 = 3'd3,
		region5 = 3'd4,
		region6 = 3'd5;

parameter 	action1 = 2'd0,
		action2 = 2'd1,
		action3 = 2'd2,
		action4 = 2'd3;

assign next_action = action;
always @ (posedge clk) begin

if (reset) begin
state<= region1;
reward <= 32'b0;
end

else begin
	case (state)

		region1:
		begin
			case(action)
				
				action1: 
				begin
					state <= region1;
					reward <= reward ;
				end
				action2: 
				begin
					state <= region4;
					reward <= reward + (32'd100<<4);
				end
				action3: 
				begin
					state <= region1;
					reward <= reward;
				end
				action4: 
				begin
					state <= region2;
					reward <= reward +  (32'd100<<4);
				end
			endcase
				
		end

		region2:
		begin
			case(action)
				
				action1: 
				begin
					state <= region2;
					reward <= reward;
				end
				action2: 
				begin
					state <= region5;
					reward <= reward + (32'd100<<4);
				end
				action3: 
				begin
					state <= region1;
					reward <= reward + (32'd100<<4);
				end
				action4: 
				begin
					state <= region3;
					reward <= reward + (32'd100<<4);
				end
			endcase
				
		end
 
		region3:
		begin
			case(action)
				
				action1: 
				begin
					state <= region3;
					reward <= reward;
				end
				action2: 
				begin
					state <= region6;
					reward <= reward + (32'd1000<<4);
				end
				action3: 
				begin
					state <= region2;
					reward <= reward + (32'd100<<4);
				end
				action4: 
				begin
					state <= region3;
					reward <= reward;
				end
			endcase
				
		end

		region4:
		begin
			case(action)
				
				action1: 
				begin
					state <= region1;
					reward <= reward + (32'd100<<4);
				end
				action2: 
				begin
					state <= region4;
					reward <= reward;
				end
				action3: 
				begin
					state <= region4;
					reward <= reward;
				end
				action4: 
				begin
					state <= region5;
					reward <= reward + (32'd100<<4);
				end
			endcase
				
		end

		region5:
		begin
			case(action)
				
				action1: 
				begin
					state <= region2;
					reward <= reward + (32'd100<<4);
				end
				action2: 
				begin
					state <= region5;
					reward <= reward ;
				end
				action3: 
				begin
					state <= region4;
					reward <= reward + (32'd100<<4);
				end
				action4: 
				begin
					state <= region6;
					reward <= reward + (32'd1000<<4);
				end
			endcase
				
		end

		region6:
		begin
			case(action)
				
				action1: 
				begin
					state <= region3;
					reward <= reward - (32'd1000<<4);
				end
				action2: 
				begin
					state <= region6;
					reward <= reward + (32'd1000<<4);
				end
				action3: 
				begin
					state <= region5;
					reward <= reward - (32'd1000<<4);
				end
				action4: 
				begin
					state <= region6;
					reward <= reward + (32'd1000<<4);
				end
			endcase
				
		end


	endcase
end
end

endmodule //robot_fsm

// LFSR_2bit: This is used as Policy Generator 1. 2 bit random number generator.  LFSR: Linear Feedback Shift Register.
// A 2 bit random number generator designed with a LFSR forms a cyclic sequence, hindering the 'random' nature of the module.
// Thus, we use a 8 bit random number generator and pick 2 bits from that to decide our state. 
module LFSR_2bit ( input clk, input reset, output reg [1:0] action);

wire [7:0] random;
LFSR_8bit module_4 ( clk, reset, random) ;
always @ (posedge clk)  begin

if (reset) action <= 2'b0;

else begin

action<= random[5:4] ; // 2 bits selected
end

end
endmodule

// LFSR_8bit: used to supplement the 2 bit random number generator
module LFSR_8bit ( input clk, input reset, output reg [7:0]random);
reg bit;

always @ (posedge clk)  begin

if (reset) random <= 8'd85;

else begin
	bit = random[7] ^ random[6] ^ random[5] ^ random[4];
	random[7:1] = random[6:0]; 
	random[0] = bit;
end
end

endmodule

//policy_generator_2: the second policy generator which bases the next action on the max value of Q. used during inference. 
module policy_generator_2 (input clk, input reset, input   signed [31:0]in0_0, input   signed [31:0]in0_1, input   signed [31:0]in0_2, input   signed [31:0]in0_3, output reg [1:0] action );

  wire signed [31:0] in0 [0:3];  // int32 [4]
  wire signed [31:0] Max_stage1_val [0:1];  // int32 [2]
  wire signed [31:0] Max_stage2_val;  // int32


  assign in0[0] = in0_0;
  assign in0[1] = in0_1;
  assign in0[2] = in0_2;
  assign in0[3] = in0_3;

  // ---- Tree max implementation ----
  // ---- Tree max stage 1 ----
  assign Max_stage1_val[0] = (in0[0] >= in0[1] ? in0[0] :
              in0[1]);
  assign Max_stage1_val[1] = (in0[2] >= in0[3] ? in0[2] :
              in0[3]);


  // ---- Tree max stage 2 ----
  assign Max_stage2_val = (Max_stage1_val[0] >= Max_stage1_val[1] ? Max_stage1_val[0] :
              Max_stage1_val[1]);

always @ (posedge clk) begin

if (reset== 1'b1) action<= 2'b0;
else begin

	if (Max_stage2_val == in0_0) action <= 2'd0;
	else if (Max_stage2_val == in0_1) action <= 2'd1;
	else if (Max_stage2_val == in0_2) action <= 2'd2;
	else action <= 2'd3;

	end

end

endmodule


//robot_high_level: connects all the modules together
module robot_high_level ( input clk, input reset, input mode, output [31:0]Q);

wire [1:0] action;
wire signed [31:0]reward;
wire [2:0] state;
wire [1:0] next_action;
wire [7:0] alpha;
wire [7:0] gamma;
// wire mode; //mode =0 training; mode = 1 inference
wire [1:0] action_1;
wire [1:0] action_2;

wire signed [31:0] Data_Type_Conversion_out1_0;
wire signed [31:0] Data_Type_Conversion_out1_1;
wire signed [31:0] Data_Type_Conversion_out1_2;
wire signed [31:0] Data_Type_Conversion_out1_3;


assign alpha = 8'b01000000;
assign gamma = 8'b01000000;

FSM module_1 ( clk, reset, action, reward, state, next_action);

Q_HW module_2(mode, clk, reset, 1'b1, state, next_action, reward, alpha,  gamma, , Q, Data_Type_Conversion_out1_0, Data_Type_Conversion_out1_1, Data_Type_Conversion_out1_2, Data_Type_Conversion_out1_3 );

LFSR_2bit module_3 (clk, reset, action_1);

policy_generator_2 module_6(clk, reset, Data_Type_Conversion_out1_0, Data_Type_Conversion_out1_1, Data_Type_Conversion_out1_2, Data_Type_Conversion_out1_3 , action_2);

assign action = mode? action_2 : action_1;

endmodule

//tb_robot_high_level: testbench 
module tb_robot_high_level();
reg clk;
reg reset;
wire [31:0] Q;
reg mode ;
robot_high_level uut( clk, reset, mode, Q);

initial begin
clk = 0;
repeat(100000)
#10 clk = ~clk; #10 $finish;
end

initial begin
reset=1; mode = 1'b0; //training
#35 reset=0;
#800000 mode = 1'b1; //inference
end

endmodule
