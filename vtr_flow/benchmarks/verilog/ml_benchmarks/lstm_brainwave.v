//`define SIMULATION_MEMORY
`define INWEIGHT_DEPTH 6400   //100x64
`define HWEIGHT_DEPTH 4096    //64x64
`define ARRAY_DEPTH 64       //64
`define INPUT_DEPTH 100	    //100
`define DATA_WIDTH 16
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16

module top(
input clk,
input reset,
input [12:0] wren_b_ext,
input [5:0] address_b_ext,
input [`uarraysize-1:0] hdata_b_ext,
input [`varraysize-1:0] xdata_b_ext,
input [`DATA_WIDTH-1:0] bias,
output [`DATA_WIDTH-1:0] ht_out
);

wire [`uarraysize-1:0] Ui_in;
wire [`varraysize-1:0] Wi_in;
wire [`uarraysize-1:0] Uf_in;
wire [`varraysize-1:0] Wf_in;
wire [`uarraysize-1:0] Uo_in;
wire [`varraysize-1:0] Wo_in;
wire [`uarraysize-1:0] Uc_in;
wire [`varraysize-1:0] Wc_in;
wire [`varraysize-1:0] x_in;
reg [`uarraysize-1:0] h_in;
wire [`uarraysize-1:0] dummyo0,dummyo1,dummyo2,dummyo3;
wire [`varraysize-1:0] dummyo4,dummyo5,dummyo6,dummyo7,dummyo8;
wire [`DATA_WIDTH-1:0] dummyo9,dummyo10,dummyo11,dummyo12,dummyo13;

reg [`uarraysize-1:0] dummyin_u;
reg [`varraysize-1:0] dummyin_v;
reg [`DATA_WIDTH-1:0] dummyin_b;

wire [`DATA_WIDTH-1:0] bi_in;
wire [`DATA_WIDTH-1:0] bf_in;
wire [`DATA_WIDTH-1:0] bo_in;
wire [`DATA_WIDTH-1:0] bc_in;
reg [`DATA_WIDTH-1:0] C_in;

wire [`varraysize-1:0] data_b_ext;
reg [5:0] inaddr; 
reg [5:0] waddr;
reg wren_a;
reg [5:0] c_count;
reg [5:0] b_count;
reg [5:0] ct_count;
reg cycle_complete;
reg [6:0] count;
reg [5:0] i,j;
reg [5:0] h_count;

wire [`DATA_WIDTH-1:0] ht;

//
//wire [`DATA_WIDTH-1:0] ht_prev[`ARRAY_DEPTH-1:0];
 
reg [`uarraysize-1:0] ht_prev;

//reg [`DATA_WIDTH-1:0] C[`ARRAY_DEPTH-1:0];
//reg [`DATA_WIDTH-1:0] Ct[`ARRAY_DEPTH-1:0];
reg [`uarraysize-1:0] Ct;
wire [`DATA_WIDTH-1:0] add_cf;
reg wren_a_ct, wren_b_cin;

assign ht_out = ht;

//assign data_b_ext = (wren_b_ext>15)? xdata_b_ext:hdata_b_ext; //Depending on whether its input weight memory or hweight memory select data

dpram_u Ui_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[0]),.data_a(dummyin_u),.data_b(hdata_b_ext),.out_a(Ui_in),.out_b(dummyo0));
dpram_u Uf_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[1]),.data_a(dummyin_u),.data_b(hdata_b_ext),.out_a(Uf_in),.out_b(dummyo1));
dpram_u Uo_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[2]),.data_a(dummyin_u),.data_b(hdata_b_ext),.out_a(Uo_in),.out_b(dummyo2));
dpram_u Uc_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[3]),.data_a(dummyin_u),.data_b(hdata_b_ext),.out_a(Uc_in),.out_b(dummyo3));
dpram_v Wi_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[4]),.data_a(dummyin_v),.data_b(xdata_b_ext),.out_a(Wi_in),.out_b(dummyo4));
dpram_v Wf_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[5]),.data_a(dummyin_v),.data_b(xdata_b_ext),.out_a(Wf_in),.out_b(dummyo5));
dpram_v Wo_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[6]),.data_a(dummyin_v),.data_b(xdata_b_ext),.out_a(Wo_in),.out_b(dummyo6));
dpram_v Wc_mem(.clk(clk),.address_a(waddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[7]),.data_a(dummyin_v),.data_b(xdata_b_ext),.out_a(Wc_in),.out_b(dummyo7));
dpram_v Xi_mem(.clk(clk),.address_a(inaddr),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[8]),.data_a(dummyin_v),.data_b(xdata_b_ext),.out_a(x_in),.out_b(dummyo8));
dpram_b bi_mem(.clk(clk),.address_a(b_count),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[9]),.data_a(dummyin_b),.data_b(bias),.out_a(bi_in),.out_b(dummyo9));
dpram_b bf_mem(.clk(clk),.address_a(b_count),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[10]),.data_a(dummyin_b),.data_b(bias),.out_a(bf_in),.out_b(dummyo10));
dpram_b bo_mem(.clk(clk),.address_a(b_count),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[11]),.data_a(dummyin_b),.data_b(bias),.out_a(bo_in),.out_b(dummyo11));
dpram_b bc_mem(.clk(clk),.address_a(b_count),.address_b(address_b_ext),.wren_a(wren_a),.wren_b(wren_b_ext[12]),.data_a(dummyin_b),.data_b(bias),.out_a(bc_in),.out_b(dummyo12));
//dpram_b Ct_mem(.clk(clk),.address_a(ct_count),.address_b(c_count),.wren_a(wren_a_ct),.wren_b(wren_b_cin),.data_a(add_cf),.data_b(),.out_a(dummyo13),.out_b(C_in));


lstm_top lstm(.clk(clk),.rst(reset),.ht_out(ht),.Ui_in(Ui_in),.Wi_in(Wi_in),.Uf_in(Uf_in),.Wf_in(Wf_in),.Uo_in(Uo_in),.Wo_in(Wo_in),
.Uc_in(Uc_in),.Wc_in(Wc_in),.x_in(x_in),.h_in(h_in),.C_in(C_in),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.add_cf(add_cf));

always @(posedge clk) begin
 if(reset == 1'b1)
  begin      
	   count <= 0;
	   b_count <=0;
	   h_count <= 0;
	   c_count <= 0;
	   ct_count <=0;
	   waddr <=0;	
	   inaddr <= 0;
	   h_in <= 0;
	   ht_prev <= 0;
	   wren_a <= 0;
	   wren_a_ct <= 1;
	   wren_b_cin <= 0;
	   cycle_complete <=0;

         for(j = 0; j < `ARRAY_DEPTH; j=j+1)
    		begin
		   Ct[j] <= 0;
	     end
	    C_in <=0;

	   //dummy ports initialize
	   dummyin_u <= 0; 
	   dummyin_v <=0;
	   dummyin_b <= 0;
 
  end
  else begin
	
	if(h_count == `ARRAY_DEPTH-1) begin
		cycle_complete <= 1;
		waddr <= 0;
		count <=0;
		b_count <= 0;
		ct_count <=0;
		c_count <= 0;
	 end
	 else begin
		cycle_complete <= 0;
    	waddr <= waddr+1;
	    count <= count+1;
	 
		if(count>5)     //delay before bias add
			b_count <= b_count+1; 

		if(count >6)  begin //delay before Cin elmul
			c_count <=c_count+1;
			case(c_count)
			0: C_in<=Ct[16*0+:16] ;
			1: C_in<=Ct[16*1+:16] ;
			2: C_in<=Ct[16*2+:16] ;
			3: C_in<=Ct[16*3+:16] ;
			4: C_in<=Ct[16*4+:16] ;
			5: C_in<=Ct[16*5+:16] ;
			6: C_in<=Ct[16*6+:16] ;
			7: C_in<=Ct[16*7+:16] ;
			8: C_in<=Ct[16*8+:16] ;
			9: C_in<=Ct[16*9+:16] ;
			10: C_in <=Ct[16*10+:16];
			11: C_in <=Ct[16*11+:16];
			12: C_in <=Ct[16*12+:16];
			13: C_in <=Ct[16*13+:16];
			14: C_in <=Ct[16*14+:16];
			15: C_in <=Ct[16*15+:16];
			16: C_in <=Ct[16*16+:16];
			17: C_in <=Ct[16*17+:16];
			18: C_in <=Ct[16*18+:16];
			19: C_in <=Ct[16*19+:16];
			20: C_in <=Ct[16*20+:16];
			21: C_in <=Ct[16*21+:16];
			22: C_in <=Ct[16*22+:16];
			23: C_in <=Ct[16*23+:16];
			24: C_in <=Ct[16*24+:16];
			25: C_in <=Ct[16*25+:16];
			26: C_in <=Ct[16*26+:16];
			27: C_in <=Ct[16*27+:16];
			28: C_in <=Ct[16*28+:16];
			29: C_in <=Ct[16*29+:16];
			30: C_in <=Ct[16*30+:16];
			31: C_in <=Ct[16*31+:16];
			32: C_in <=Ct[16*32+:16];
			33: C_in <=Ct[16*33+:16];
			34: C_in <=Ct[16*34+:16];
			35: C_in <=Ct[16*35+:16];
			36: C_in <=Ct[16*36+:16];
			37: C_in <=Ct[16*37+:16];
			38: C_in <=Ct[16*38+:16];
			39: C_in <=Ct[16*39+:16];
			40: C_in <=Ct[16*40+:16];
			41: C_in <=Ct[16*41+:16];
			42: C_in <=Ct[16*42+:16];
			43: C_in <=Ct[16*43+:16];
			44: C_in <=Ct[16*44+:16];
			45: C_in <=Ct[16*45+:16];
			46: C_in <=Ct[16*46+:16];
			47: C_in <=Ct[16*47+:16];
			48: C_in <=Ct[16*48+:16];
			49: C_in <=Ct[16*49+:16];
			50: C_in <=Ct[16*50+:16];
			51: C_in <=Ct[16*51+:16];
			52: C_in <=Ct[16*52+:16];
			53: C_in <=Ct[16*53+:16];
			54: C_in <=Ct[16*54+:16];
			55: C_in <=Ct[16*55+:16];
			56: C_in <=Ct[16*56+:16];
			57: C_in <=Ct[16*57+:16];
			58: C_in <=Ct[16*58+:16];
			59: C_in <=Ct[16*59+:16];
			60: C_in <=Ct[16*60+:16];
			61: C_in <=Ct[16*61+:16];
			62: C_in <=Ct[16*62+:16];
			63: C_in <=Ct[16*63+:16];
			default : C_in <= 0;
		endcase	
		end

		if(count >7) begin  //for storing output of Ct
			ct_count <= ct_count+1;
		 //storing cell state
			case(ct_count)
			0:	Ct[16*0+:16] <= add_cf;
			1:	Ct[16*1+:16] <= add_cf;
			2:	Ct[16*2+:16] <= add_cf;
			3:	Ct[16*3+:16] <= add_cf;
			4:	Ct[16*4+:16] <= add_cf;
			5:	Ct[16*5+:16] <= add_cf;
			6:	Ct[16*6+:16] <= add_cf;
			7:	Ct[16*7+:16] <= add_cf;
			8:	Ct[16*8+:16] <= add_cf;
			9:	Ct[16*9+:16] <= add_cf;
			10:	Ct[16*10+:16] <=add_cf;
			11:	Ct[16*11+:16] <=add_cf;
			12:	Ct[16*12+:16] <=add_cf;
			13:	Ct[16*13+:16] <=add_cf;
			14:	Ct[16*14+:16] <=add_cf;
			15:	Ct[16*15+:16] <=add_cf;
			16:	Ct[16*16+:16] <=add_cf;
			17:	Ct[16*17+:16] <=add_cf;
			18:	Ct[16*18+:16] <=add_cf;
			19:	Ct[16*19+:16] <=add_cf;
			20:	Ct[16*20+:16] <=add_cf;
			21:	Ct[16*21+:16] <=add_cf;
			22:	Ct[16*22+:16] <=add_cf;
			23:	Ct[16*23+:16] <=add_cf;
			24:	Ct[16*24+:16] <=add_cf;
			25:	Ct[16*25+:16] <=add_cf;
			26:	Ct[16*26+:16] <=add_cf;
			27:	Ct[16*27+:16] <=add_cf;
			28:	Ct[16*28+:16] <=add_cf;
			29:	Ct[16*29+:16] <=add_cf;
			30:	Ct[16*30+:16] <=add_cf;
			31:	Ct[16*31+:16] <=add_cf;
			32:	Ct[16*32+:16] <=add_cf;
			33:	Ct[16*33+:16] <=add_cf;
			34:	Ct[16*34+:16] <=add_cf;
			35:	Ct[16*35+:16] <=add_cf;
			36:	Ct[16*36+:16] <=add_cf;
			37:	Ct[16*37+:16] <=add_cf;
			38:	Ct[16*38+:16] <=add_cf;
			39:	Ct[16*39+:16] <=add_cf;
			40:	Ct[16*40+:16] <=add_cf;
			41:	Ct[16*41+:16] <=add_cf;
			42:	Ct[16*42+:16] <=add_cf;
			43:	Ct[16*43+:16] <=add_cf;
			44:	Ct[16*44+:16] <=add_cf;
			45:	Ct[16*45+:16] <=add_cf;
			46:	Ct[16*46+:16] <=add_cf;
			47:	Ct[16*47+:16] <=add_cf;
			48:	Ct[16*48+:16] <=add_cf;
			49:	Ct[16*49+:16] <=add_cf;
			50:	Ct[16*50+:16] <=add_cf;
			51:	Ct[16*51+:16] <=add_cf;
			52:	Ct[16*52+:16] <=add_cf;
			53:	Ct[16*53+:16] <=add_cf;
			54:	Ct[16*54+:16] <=add_cf;
			55:	Ct[16*55+:16] <=add_cf;
			56:	Ct[16*56+:16] <=add_cf;
			57:	Ct[16*57+:16] <=add_cf;
			58:	Ct[16*58+:16] <=add_cf;
			59:	Ct[16*59+:16] <=add_cf;
			60:	Ct[16*60+:16] <=add_cf;
			61:	Ct[16*61+:16] <=add_cf;
			62:	Ct[16*62+:16] <=add_cf;
			63:	Ct[16*63+:16] <=add_cf;
			default : Ct <= 0;
		 endcase
		end
		if(count >10) begin
			h_count <= h_count + 1;
			case(h_count)
			0:	ht_prev[16*0+:16] <= ht;
			1:	ht_prev[16*1+:16] <= ht;
			2:	ht_prev[16*2+:16] <= ht;
			3:	ht_prev[16*3+:16] <= ht;
			4:	ht_prev[16*4+:16] <= ht;
			5:	ht_prev[16*5+:16] <= ht;
			6:	ht_prev[16*6+:16] <= ht;
			7:	ht_prev[16*7+:16] <= ht;
			8:	ht_prev[16*8+:16] <= ht;
			9:	ht_prev[16*9+:16] <= ht;
			10:	ht_prev[16*10+:16] <= ht;
			11:	ht_prev[16*11+:16] <= ht;
			12:	ht_prev[16*12+:16] <= ht;
			13:	ht_prev[16*13+:16] <= ht;
			14:	ht_prev[16*14+:16] <= ht;
			15:	ht_prev[16*15+:16] <= ht;
			16:	ht_prev[16*16+:16] <= ht;
			17:	ht_prev[16*17+:16] <= ht;
			18:	ht_prev[16*18+:16] <= ht;
			19:	ht_prev[16*19+:16] <= ht;
			20:	ht_prev[16*20+:16] <= ht;
			21:	ht_prev[16*21+:16] <= ht;
			22:	ht_prev[16*22+:16] <= ht;
			23:	ht_prev[16*23+:16] <= ht;
			24:	ht_prev[16*24+:16] <= ht;
			25:	ht_prev[16*25+:16] <= ht;
			26:	ht_prev[16*26+:16] <= ht;
			27:	ht_prev[16*27+:16] <= ht;
			28:	ht_prev[16*28+:16] <= ht;
			29:	ht_prev[16*29+:16] <= ht;
			30:	ht_prev[16*30+:16] <= ht;
			31:	ht_prev[16*31+:16] <= ht;
			32:	ht_prev[16*32+:16] <= ht;
			33:	ht_prev[16*33+:16] <= ht;
			34:	ht_prev[16*34+:16] <= ht;
			35:	ht_prev[16*35+:16] <= ht;
			36:	ht_prev[16*36+:16] <= ht;
			37:	ht_prev[16*37+:16] <= ht;
			38:	ht_prev[16*38+:16] <= ht;
			39:	ht_prev[16*39+:16] <= ht;
			40:	ht_prev[16*40+:16] <= ht;
			41:	ht_prev[16*41+:16] <= ht;
			42:	ht_prev[16*42+:16] <= ht;
			43:	ht_prev[16*43+:16] <= ht;
			44:	ht_prev[16*44+:16] <= ht;
			45:	ht_prev[16*45+:16] <= ht;
			46:	ht_prev[16*46+:16] <= ht;
			47:	ht_prev[16*47+:16] <= ht;
			48:	ht_prev[16*48+:16] <= ht;
			49:	ht_prev[16*49+:16] <= ht;
			50:	ht_prev[16*50+:16] <= ht;
			51:	ht_prev[16*51+:16] <= ht;
			52:	ht_prev[16*52+:16] <= ht;
			53:	ht_prev[16*53+:16] <= ht;
			54:	ht_prev[16*54+:16] <= ht;
			55:	ht_prev[16*55+:16] <= ht;
			56:	ht_prev[16*56+:16] <= ht;
			57:	ht_prev[16*57+:16] <= ht;
			58:	ht_prev[16*58+:16] <= ht;
			59:	ht_prev[16*59+:16] <= ht;
			60:	ht_prev[16*60+:16] <= ht;
			61:	ht_prev[16*61+:16] <= ht;
			62:	ht_prev[16*62+:16] <= ht;
			63:	ht_prev[16*63+:16] <= ht;
			default: ht_prev <= 0;
			endcase
		 end
			
	end
		
//        ht_prev[h_count] <= ht;    //storing ht outputs

	if(h_count == `ARRAY_DEPTH-2) begin //to fetch next input,ram needs 1 extra cycle to give op
		inaddr <= inaddr+1;
	end

	if(cycle_complete==1) begin
		  h_in <= ht_prev; 
	end

  end
 end
 
  

endmodule



module dpram_v(	
input clk,
input [(6-1):0] address_a,
input [(6-1):0] address_b,
input  wren_a,
input  wren_b,
input [(`varraysize-1):0] data_a,
input [(`varraysize-1):0] data_b,
output reg [(`varraysize-1):0] out_a,
output reg [(`varraysize-1):0] out_b
);


`ifdef SIMULATION_MEMORY

reg [`varraysize-1:0] ram[`ARRAY_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  
always @ (posedge clk) begin 
  if (wren_b) begin
      ram[address_b] <= data_b;
  end 
  else begin
      out_b <= ram[address_b];
  end
end

`else

dual_port_ram u_dual_port_ram(
.addr1(address_a),
.we1(wren_a),
.data1(data_a),
.out1(out_a),
.addr2(address_b),
.we2(wren_b),
.data2(data_b),
.out2(out_b),
.clk(clk)
);

`endif

endmodule

module dpram_u (	
input clk,
input [(6-1):0] address_a,
input [(6-1):0] address_b,
input  wren_a,
input  wren_b,
input [(`uarraysize-1):0] data_a,
input [(`uarraysize-1):0] data_b,
output reg [(`uarraysize-1):0] out_a,
output reg [(`uarraysize-1):0] out_b
);


`ifdef SIMULATION_MEMORY

reg [`uarraysize-1:0] ram[`ARRAY_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  
always @ (posedge clk) begin 
  if (wren_b) begin
      ram[address_b] <= data_b;
  end 
  else begin
      out_b <= ram[address_b];
  end
end

`else

dual_port_ram u_dual_port_ram(
.addr1(address_a),
.we1(wren_a),
.data1(data_a),
.out1(out_a),
.addr2(address_b),
.we2(wren_b),
.data2(data_b),
.out2(out_b),
.clk(clk)
);

`endif

endmodule

module dpram_b (	
input clk,
input [(6-1):0] address_a,
input [(6-1):0] address_b,
input  wren_a,
input  wren_b,
input [(`DATA_WIDTH-1):0] data_a,
input [(`DATA_WIDTH-1):0] data_b,
output reg [(`DATA_WIDTH-1):0] out_a,
output reg [(`DATA_WIDTH-1):0] out_b
);


`ifdef SIMULATION_MEMORY

reg [`DATA_WIDTH-1:0] ram[`ARRAY_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  
always @ (posedge clk) begin 
  if (wren_b) begin
      ram[address_b] <= data_b;
  end 
  else begin
      out_b <= ram[address_b];
  end
end

`else

dual_port_ram u_dual_port_ram(
.addr1(address_a),
.we1(wren_a),
.data1(data_a),
.out1(out_a),
.addr2(address_b),
.we2(wren_b),
.data2(data_b),
.out2(out_b),
.clk(clk)
);

`endif

endmodule


module lstm_top(
input clk,
input rst,
output  [15:0] ht_out,
input [`uarraysize-1:0] Ui_in,
input [`varraysize-1:0] Wi_in,
input [`uarraysize-1:0] Uf_in,
input [`varraysize-1:0] Wf_in,
input [`uarraysize-1:0] Uo_in,
input [`varraysize-1:0] Wo_in,
input [`uarraysize-1:0] Uc_in,
input [`varraysize-1:0] Wc_in,
input [`varraysize-1:0] x_in,
input [`uarraysize-1:0] h_in,
input [`DATA_WIDTH-1:0] bi_in,
input [`DATA_WIDTH-1:0] bf_in,
input [`DATA_WIDTH-1:0] bo_in,
input [`DATA_WIDTH-1:0] bc_in,
input [`DATA_WIDTH-1:0] C_in,
output [`DATA_WIDTH-1:0] add_cf);


wire [`uarraysize-1:0] mulout_ih;
wire [`uarraysize-1:0] mulout_fh;
wire [`uarraysize-1:0] mulout_ch;
wire [`uarraysize-1:0] mulout_oh;

wire [`varraysize-1:0] mulout_ix;
wire [`varraysize-1:0] mulout_fx;
wire [`varraysize-1:0] mulout_cx;
wire [`varraysize-1:0] mulout_ox;

wire [`DATA_WIDTH-1:0] macout_ix;
wire [`DATA_WIDTH-1:0] macout_ih;
wire [`DATA_WIDTH-1:0] add_i;
wire [`DATA_WIDTH-1:0] macout_fx;
wire [`DATA_WIDTH-1:0] macout_fh;
wire [`DATA_WIDTH-1:0] add_f;
wire [`DATA_WIDTH-1:0] macout_cx;
wire [`DATA_WIDTH-1:0] macout_ch;
wire [`DATA_WIDTH-1:0] add_c;
wire [`DATA_WIDTH-1:0] macout_ox;
wire [`DATA_WIDTH-1:0] macout_oh;
wire [`DATA_WIDTH-1:0] add_o;
//wire [`DATA_WIDTH-1:0] add_cf;


wire [`DATA_WIDTH-1:0] addbias_i;
wire [`DATA_WIDTH-1:0] addbias_f;
wire [`DATA_WIDTH-1:0] addbias_o;
wire [`DATA_WIDTH-1:0] addbias_c;

wire [`DATA_WIDTH-1:0] sig_io;
wire [`DATA_WIDTH-1:0] sig_fo;
wire [`DATA_WIDTH-1:0] sig_oo;


wire [`DATA_WIDTH-1:0] elmul_fo;
wire [`DATA_WIDTH-1:0] elmul_co;
wire [`DATA_WIDTH-1:0] tan_c;
wire [`DATA_WIDTH-1:0] tan_h;


wire [15:0] ht;


assign ht_out = ht;

reg [15:0] mac_fx_reg,mac_fh_reg,add_f_reg,addb_f_reg,sig_fo_reg;
reg [15:0] mac_ix_reg,mac_ih_reg,add_i_reg,addb_i_reg,sig_io_reg;
reg [15:0] mac_ox_reg,mac_oh_reg, add_o_reg,addb_o_reg,sig_oo_reg;
reg [15:0] mac_cx_reg,mac_ch_reg, add_c_reg,addb_c_reg,sig_co_reg;
reg [15:0] tan_c_reg,elmul_co_reg,add_cf_reg,tan_h_reg,elmul_fo_reg;

reg [`uarraysize-1:0] mulout_ih_reg,mulout_fh_reg,mulout_oh_reg,mulout_ch_reg;
reg [`varraysize-1:0] mulout_ix_reg,mulout_fx_reg,mulout_ox_reg,mulout_cx_reg;

reg [15:0] sig_oo_d1,sig_oo_d2,sig_oo_d3;

always @(posedge clk) begin

//Pipeline Registers
		mulout_fx_reg <= mulout_fx;
		mulout_fh_reg <= mulout_fh;
		mac_fx_reg <= macout_fx;
		mac_fh_reg <= macout_fh;
		add_f_reg <= add_f;
		addb_f_reg <= addbias_f; 
		sig_fo_reg <= sig_fo;
		elmul_fo_reg <= elmul_fo; //check if need to delay to wait for elmul_co

		mulout_ix_reg <= mulout_ix;
		mulout_ih_reg <= mulout_ih;
		mac_ix_reg <= macout_ix;
		mac_ih_reg <= macout_ih;
		add_i_reg <= add_i;
		addb_i_reg <= addbias_i; 
		sig_io_reg <= sig_io;
		
		mulout_ox_reg <= mulout_ox;
		mulout_oh_reg <= mulout_oh;
		mac_ox_reg <= macout_ox;
		mac_oh_reg <= macout_oh;
		add_o_reg <= add_o;
		addb_o_reg <= addbias_o; 
		sig_oo_reg <= sig_oo;   


		sig_oo_d1 <= sig_oo_reg; //delaying sig_oo by 3 cycles to feed to c gate
		sig_oo_d2 <= sig_oo_d1;
		sig_oo_d3 <= sig_oo_d2;

		mulout_cx_reg <= mulout_cx;
		mulout_ch_reg <= mulout_ch;
		mac_cx_reg <= macout_cx;
		mac_ch_reg <= macout_ch;
		add_c_reg <= add_c;
		addb_c_reg <= addbias_c; 
		tan_c_reg <= tan_c;
		elmul_co_reg <= elmul_co;
		add_cf_reg <= add_cf;
		tan_h_reg <= tan_h; 

end


//FORGET GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wf_in),.tmp(mulout_fx));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) f_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uf_in),.tmp(mulout_fh));
  vecmat_add_x #(`varraysize,`INPUT_DEPTH) f_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_fx_reg),.data_out(macout_fx));
  vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) f_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_fh_reg),.data_out(macout_fh));
  qadd2 f_gate_add(.a(mac_fx_reg),.b(mac_fh_reg),.c(add_f));
  qadd2 f_gate_biasadd(.a(bf_in),.b(add_f),.c(addbias_f));
  sigmoid sigf(addb_f_reg,sig_fo);
  //qmult #(12,16) f_elmul(.i_multiplicand(sig_fo_reg),.i_multiplier(C_in),.o_result(elmul_fo),.ovr(overflow0));
  signedmul f_elmul(.a(sig_fo_reg),.b(C_in),.c(elmul_fo));

//INPUT GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) i_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wi_in),.tmp(mulout_ix));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) i_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Ui_in),.tmp(mulout_ih));
  vecmat_add_x #(`varraysize,`INPUT_DEPTH) i_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_ix_reg),.data_out(macout_ix));
  vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) i_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_ih_reg),.data_out(macout_ih));
  qadd2 i_gate_add(.a(mac_ix_reg),.b(mac_ih_reg),.c(add_i));
  qadd2 i_gate_biasadd(.a(bi_in),.b(add_i),.c(addbias_i));
  sigmoid sigi(addb_i_reg,sig_io);

//OUTPUT GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) o_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wo_in),.tmp(mulout_ox));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) o_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uo_in),.tmp(mulout_oh));
  vecmat_add_x #(`varraysize,`INPUT_DEPTH) o_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_ox_reg),.data_out(macout_ox));
  vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) o_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_oh_reg),.data_out(macout_oh));
  qadd2 o_gate_add(.a(mac_ox_reg),.b(mac_oh_reg),.c(add_o));
  qadd2 o_gate_biasadd(.a(bo_in),.b(add_o),.c(addbias_o));
  sigmoid sigo(addb_o_reg,sig_oo);

//CELL STATE GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) c_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wc_in),.tmp(mulout_cx));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) c_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uc_in),.tmp(mulout_ch));
  vecmat_add_x #(`varraysize,`INPUT_DEPTH) c_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_cx_reg),.data_out(macout_cx));
  vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) c_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_ch_reg),.data_out(macout_ch));
  qadd2 c_gate_add(.a(mac_cx_reg),.b(mac_ch_reg),.c(add_c));
  qadd2 c_gate_biasadd(.a(bc_in),.b(add_c),.c(addbias_c)); 
  tanh tan_c1(addb_c_reg,tan_c);
  //qmult #(12,16) c_elmul(.i_multiplicand(tan_c_reg),.i_multiplier(sig_io_reg),.o_result(elmul_co),.ovr(overflow0));
  signedmul c_elmul(.a(tan_c_reg),.b(sig_io_reg),.c(elmul_co));	  
  qadd2 cf_gate_add(.a(elmul_co_reg),.b(elmul_fo_reg),.c(add_cf));
  tanh tan_c2(add_cf_reg,tan_h);
  //qmult #(12,16) h_elmul(.i_multiplicand(tan_h_reg),.i_multiplier(sig_oo_d3),.o_result(ht),.ovr(overflow0));
  signedmul h_elmul(.a(tan_h_reg),.b(sig_oo_d3),.c(ht));



endmodule
 

module vecmat_mul_h #( parameter uarraysize=1024,parameter vectwidth=64)  //,matsize=64)   // varraysize=1024 vectwidth=64,matsize=4096
(
 input clk,
 input reset,
 input [uarraysize-1:0] data,
 input [uarraysize-1:0] W,
 //output reg [15:0] data_out
 output [uarraysize-1:0] tmp
 );
  
 //wire [uarraysize-1:0] tmp;

 reg [uarraysize-1:0] matrix;
 reg [uarraysize-1:0] vector;


 always @(posedge clk) begin
	if(~reset) begin

	        vector <= data;
		matrix <= W;
    
	end
 end
	 
  /*genvar j;
  generate 
  for (j=0;j<vectwidth;j=j+1) begin
          signedmul mult_u0(.a(vector[j*16+:16]),.b(matrix[j*16+:16]),.c(tmp[j*16+:16]));
  end
  endgenerate*/

   	signedmul mult_u0(.a(vector[0*16+:16]),.b(matrix[0*16+:16]),.c(tmp[0*16+:16]));
	signedmul mult_u1(.a(vector[1*16+:16]),.b(matrix[1*16+:16]),.c(tmp[1*16+:16]));
	signedmul mult_u2(.a(vector[2*16+:16]),.b(matrix[2*16+:16]),.c(tmp[2*16+:16]));
	signedmul mult_u3(.a(vector[3*16+:16]),.b(matrix[3*16+:16]),.c(tmp[3*16+:16]));
	signedmul mult_u4(.a(vector[4*16+:16]),.b(matrix[4*16+:16]),.c(tmp[4*16+:16]));
	signedmul mult_u5(.a(vector[5*16+:16]),.b(matrix[5*16+:16]),.c(tmp[5*16+:16]));
	signedmul mult_u6(.a(vector[6*16+:16]),.b(matrix[6*16+:16]),.c(tmp[6*16+:16]));
	signedmul mult_u7(.a(vector[7*16+:16]),.b(matrix[7*16+:16]),.c(tmp[7*16+:16]));
	signedmul mult_u8(.a(vector[8*16+:16]),.b(matrix[8*16+:16]),.c(tmp[8*16+:16]));
	signedmul mult_u9(.a(vector[9*16+:16]),.b(matrix[9*16+:16]),.c(tmp[9*16+:16]));
	signedmul mult_u10(.a(vector[10*16+:16]),.b(matrix[10*16+:16]),.c(tmp[10*16+:16]));
	signedmul mult_u11(.a(vector[11*16+:16]),.b(matrix[11*16+:16]),.c(tmp[11*16+:16]));
	signedmul mult_u12(.a(vector[12*16+:16]),.b(matrix[12*16+:16]),.c(tmp[12*16+:16]));
	signedmul mult_u13(.a(vector[13*16+:16]),.b(matrix[13*16+:16]),.c(tmp[13*16+:16]));
	signedmul mult_u14(.a(vector[14*16+:16]),.b(matrix[14*16+:16]),.c(tmp[14*16+:16]));
	signedmul mult_u15(.a(vector[15*16+:16]),.b(matrix[15*16+:16]),.c(tmp[15*16+:16]));
	signedmul mult_u16(.a(vector[16*16+:16]),.b(matrix[16*16+:16]),.c(tmp[16*16+:16]));
	signedmul mult_u17(.a(vector[17*16+:16]),.b(matrix[17*16+:16]),.c(tmp[17*16+:16]));
	signedmul mult_u18(.a(vector[18*16+:16]),.b(matrix[18*16+:16]),.c(tmp[18*16+:16]));
	signedmul mult_u19(.a(vector[19*16+:16]),.b(matrix[19*16+:16]),.c(tmp[19*16+:16]));
	signedmul mult_u20(.a(vector[20*16+:16]),.b(matrix[20*16+:16]),.c(tmp[20*16+:16]));
	signedmul mult_u21(.a(vector[21*16+:16]),.b(matrix[21*16+:16]),.c(tmp[21*16+:16]));
	signedmul mult_u22(.a(vector[22*16+:16]),.b(matrix[22*16+:16]),.c(tmp[22*16+:16]));
	signedmul mult_u23(.a(vector[23*16+:16]),.b(matrix[23*16+:16]),.c(tmp[23*16+:16]));
	signedmul mult_u24(.a(vector[24*16+:16]),.b(matrix[24*16+:16]),.c(tmp[24*16+:16]));
	signedmul mult_u25(.a(vector[25*16+:16]),.b(matrix[25*16+:16]),.c(tmp[25*16+:16]));
	signedmul mult_u26(.a(vector[26*16+:16]),.b(matrix[26*16+:16]),.c(tmp[26*16+:16]));
	signedmul mult_u27(.a(vector[27*16+:16]),.b(matrix[27*16+:16]),.c(tmp[27*16+:16]));
	signedmul mult_u28(.a(vector[28*16+:16]),.b(matrix[28*16+:16]),.c(tmp[28*16+:16]));
	signedmul mult_u29(.a(vector[29*16+:16]),.b(matrix[29*16+:16]),.c(tmp[29*16+:16]));
	signedmul mult_u30(.a(vector[30*16+:16]),.b(matrix[30*16+:16]),.c(tmp[30*16+:16]));
	signedmul mult_u31(.a(vector[31*16+:16]),.b(matrix[31*16+:16]),.c(tmp[31*16+:16]));
	signedmul mult_u32(.a(vector[32*16+:16]),.b(matrix[32*16+:16]),.c(tmp[32*16+:16]));
	signedmul mult_u33(.a(vector[33*16+:16]),.b(matrix[33*16+:16]),.c(tmp[33*16+:16]));
	signedmul mult_u34(.a(vector[34*16+:16]),.b(matrix[34*16+:16]),.c(tmp[34*16+:16]));
	signedmul mult_u35(.a(vector[35*16+:16]),.b(matrix[35*16+:16]),.c(tmp[35*16+:16]));
	signedmul mult_u36(.a(vector[36*16+:16]),.b(matrix[36*16+:16]),.c(tmp[36*16+:16]));
	signedmul mult_u37(.a(vector[37*16+:16]),.b(matrix[37*16+:16]),.c(tmp[37*16+:16]));
	signedmul mult_u38(.a(vector[38*16+:16]),.b(matrix[38*16+:16]),.c(tmp[38*16+:16]));
	signedmul mult_u39(.a(vector[39*16+:16]),.b(matrix[39*16+:16]),.c(tmp[39*16+:16]));
	signedmul mult_u40(.a(vector[40*16+:16]),.b(matrix[40*16+:16]),.c(tmp[40*16+:16]));
	signedmul mult_u41(.a(vector[41*16+:16]),.b(matrix[41*16+:16]),.c(tmp[41*16+:16]));
	signedmul mult_u42(.a(vector[42*16+:16]),.b(matrix[42*16+:16]),.c(tmp[42*16+:16]));
	signedmul mult_u43(.a(vector[43*16+:16]),.b(matrix[43*16+:16]),.c(tmp[43*16+:16]));
	signedmul mult_u44(.a(vector[44*16+:16]),.b(matrix[44*16+:16]),.c(tmp[44*16+:16]));
	signedmul mult_u45(.a(vector[45*16+:16]),.b(matrix[45*16+:16]),.c(tmp[45*16+:16]));
	signedmul mult_u46(.a(vector[46*16+:16]),.b(matrix[46*16+:16]),.c(tmp[46*16+:16]));
	signedmul mult_u47(.a(vector[47*16+:16]),.b(matrix[47*16+:16]),.c(tmp[47*16+:16]));
	signedmul mult_u48(.a(vector[48*16+:16]),.b(matrix[48*16+:16]),.c(tmp[48*16+:16]));
	signedmul mult_u49(.a(vector[49*16+:16]),.b(matrix[49*16+:16]),.c(tmp[49*16+:16]));
	signedmul mult_u50(.a(vector[50*16+:16]),.b(matrix[50*16+:16]),.c(tmp[50*16+:16]));
	signedmul mult_u51(.a(vector[51*16+:16]),.b(matrix[51*16+:16]),.c(tmp[51*16+:16]));
	signedmul mult_u52(.a(vector[52*16+:16]),.b(matrix[52*16+:16]),.c(tmp[52*16+:16]));
	signedmul mult_u53(.a(vector[53*16+:16]),.b(matrix[53*16+:16]),.c(tmp[53*16+:16]));
	signedmul mult_u54(.a(vector[54*16+:16]),.b(matrix[54*16+:16]),.c(tmp[54*16+:16]));
	signedmul mult_u55(.a(vector[55*16+:16]),.b(matrix[55*16+:16]),.c(tmp[55*16+:16]));
	signedmul mult_u56(.a(vector[56*16+:16]),.b(matrix[56*16+:16]),.c(tmp[56*16+:16]));
	signedmul mult_u57(.a(vector[57*16+:16]),.b(matrix[57*16+:16]),.c(tmp[57*16+:16]));
	signedmul mult_u58(.a(vector[58*16+:16]),.b(matrix[58*16+:16]),.c(tmp[58*16+:16]));
	signedmul mult_u59(.a(vector[59*16+:16]),.b(matrix[59*16+:16]),.c(tmp[59*16+:16]));
	signedmul mult_u60(.a(vector[60*16+:16]),.b(matrix[60*16+:16]),.c(tmp[60*16+:16]));
	signedmul mult_u61(.a(vector[61*16+:16]),.b(matrix[61*16+:16]),.c(tmp[61*16+:16]));
	signedmul mult_u62(.a(vector[62*16+:16]),.b(matrix[62*16+:16]),.c(tmp[62*16+:16]));
	signedmul mult_u63(.a(vector[63*16+:16]),.b(matrix[63*16+:16]),.c(tmp[63*16+:16]));
	
endmodule                    

module vecmat_add_h #(parameter uarraysize=1024,parameter vectwidth=64)
 (
 input clk,reset,
 input [uarraysize-1:0] mulout,
 output reg [15:0] data_out
 );
           
 wire [15:0] tmp0, tmp1 ,tmp2 ,tmp3 ,tmp4 ,tmp5 ,tmp6 ,tmp7 ,tmp8 ,tmp9 ,tmp10 ,tmp11 ,tmp12 ,tmp13 ,tmp14 ,tmp15 ,tmp16 ,tmp17 ,tmp18 ,tmp19 ,tmp20 ,tmp21 ,tmp22 ,tmp23 ,tmp24 ,tmp25 ,tmp26 ,tmp27 ,tmp28 ,tmp29 ,tmp30 ,tmp31 ,tmp32 ,tmp33 ,tmp34 ,tmp35 ,tmp36 ,tmp37 ,tmp38 ,tmp39 ,tmp40 ,tmp41 ,tmp42 ,tmp43 ,tmp44 ,tmp45 ,tmp46 ,tmp47 ,tmp48 ,tmp49 ,tmp50,tmp51 ,tmp52 ,tmp53,tmp54 ,tmp55 ,tmp56 ,tmp57 ,tmp58, tmp59 ,tmp60 ,tmp61,tmp62; 
 reg[31:0] i;
 reg [15:0] ff1,ff3,ff5,ff7,ff9,ff11,ff13,ff15,ff17,ff19,ff21,ff23,ff25,ff27,ff29,ff31;

 always @(posedge clk) begin
	if(~reset) begin
		data_out <= tmp61;

		//adding a flop pipeline stage
		ff1 <= tmp1;
		ff3 <= tmp3;
		ff5 <= tmp5;
		ff7 <= tmp7;
		ff9 <= tmp9;
		ff11 <= tmp11;
		ff13 <= tmp13;
		ff15 <= tmp15;
		ff17 <= tmp17;
		ff19 <= tmp19;
		ff21 <= tmp21;
		ff23 <= tmp23;
		ff25 <= tmp25;
		ff27 <= tmp27;
		ff29 <= tmp29;
		ff31 <= tmp31;
	end   
 end     
                                                        
           // fixed point addition  
        	qadd2 Add_u0(.a(mulout[16*0+:16]),.b(mulout[16*1+:16]),.c(tmp0));
		qadd2 Add_u2(.a(mulout[16*2+:16]),.b(mulout[16*3+:16]),.c(tmp2));
		qadd2 Add_u4(.a(mulout[16*4+:16]),.b(mulout[16*5+:16]),.c(tmp4));
		qadd2 Add_u6(.a(mulout[16*6+:16]),.b(mulout[16*7+:16]),.c(tmp6));
		qadd2 Add_u8(.a(mulout[16*8+:16]),.b(mulout[16*9+:16]),.c(tmp8));
		qadd2 Add_u10(.a(mulout[16*10+:16]),.b(mulout[16*11+:16]),.c(tmp10));
		qadd2 Add_u12(.a(mulout[16*12+:16]),.b(mulout[16*13+:16]),.c(tmp12));
		qadd2 Add_u14(.a(mulout[16*14+:16]),.b(mulout[16*15+:16]),.c(tmp14));
		qadd2 Add_u16(.a(mulout[16*16+:16]),.b(mulout[16*17+:16]),.c(tmp16));
		qadd2 Add_u18(.a(mulout[16*18+:16]),.b(mulout[16*19+:16]),.c(tmp18));
		qadd2 Add_u20(.a(mulout[16*20+:16]),.b(mulout[16*21+:16]),.c(tmp20));
		qadd2 Add_u22(.a(mulout[16*22+:16]),.b(mulout[16*23+:16]),.c(tmp22));
		qadd2 Add_u24(.a(mulout[16*24+:16]),.b(mulout[16*25+:16]),.c(tmp24));
		qadd2 Add_u26(.a(mulout[16*26+:16]),.b(mulout[16*27+:16]),.c(tmp26));
		qadd2 Add_u28(.a(mulout[16*28+:16]),.b(mulout[16*29+:16]),.c(tmp28));
		qadd2 Add_u30(.a(mulout[16*30+:16]),.b(mulout[16*31+:16]),.c(tmp30));
		qadd2 Add_u32(.a(mulout[16*32+:16]),.b(mulout[16*33+:16]),.c(tmp32));
		qadd2 Add_u34(.a(mulout[16*34+:16]),.b(mulout[16*35+:16]),.c(tmp34));
		qadd2 Add_u36(.a(mulout[16*36+:16]),.b(mulout[16*37+:16]),.c(tmp36));
		qadd2 Add_u38(.a(mulout[16*38+:16]),.b(mulout[16*39+:16]),.c(tmp38));
		qadd2 Add_u40(.a(mulout[16*40+:16]),.b(mulout[16*41+:16]),.c(tmp40));
		qadd2 Add_u42(.a(mulout[16*42+:16]),.b(mulout[16*43+:16]),.c(tmp42));
		qadd2 Add_u44(.a(mulout[16*44+:16]),.b(mulout[16*45+:16]),.c(tmp44));
		qadd2 Add_u46(.a(mulout[16*46+:16]),.b(mulout[16*47+:16]),.c(tmp46));
		qadd2 Add_u48(.a(mulout[16*48+:16]),.b(mulout[16*49+:16]),.c(tmp48));
		qadd2 Add_u50(.a(mulout[16*50+:16]),.b(mulout[16*51+:16]),.c(tmp50));
		qadd2 Add_u52(.a(mulout[16*52+:16]),.b(mulout[16*53+:16]),.c(tmp52));
		qadd2 Add_u54(.a(mulout[16*54+:16]),.b(mulout[16*55+:16]),.c(tmp54));
		qadd2 Add_u56(.a(mulout[16*56+:16]),.b(mulout[16*57+:16]),.c(tmp56));
		qadd2 Add_u58(.a(mulout[16*58+:16]),.b(mulout[16*59+:16]),.c(tmp58));
		qadd2 Add_u60(.a(mulout[16*60+:16]),.b(mulout[16*61+:16]),.c(tmp60));
		qadd2 Add_u62(.a(mulout[16*62+:16]),.b(mulout[16*63+:16]),.c(tmp62));
            
			qadd2 Add_u1(.a(tmp0),.b(tmp2),.c(tmp1));
			qadd2 Add_u3(.a(tmp4),.b(tmp6),.c(tmp3));
			qadd2 Add_u5(.a(tmp8),.b(tmp10),.c(tmp5));
			qadd2 Add_u7(.a(tmp12),.b(tmp14),.c(tmp7));
			qadd2 Add_u9(.a(tmp16),.b(tmp18),.c(tmp9));
			qadd2 Add_u11(.a(tmp20),.b(tmp22),.c(tmp11));
			qadd2 Add_u13(.a(tmp24),.b(tmp26),.c(tmp13));
			qadd2 Add_u15(.a(tmp28),.b(tmp30),.c(tmp15));
			qadd2 Add_u17(.a(tmp32),.b(tmp34),.c(tmp17));
			qadd2 Add_u19(.a(tmp36),.b(tmp38),.c(tmp19));
			qadd2 Add_u21(.a(tmp40),.b(tmp42),.c(tmp21));
			qadd2 Add_u23(.a(tmp44),.b(tmp46),.c(tmp23));
			qadd2 Add_u25(.a(tmp48),.b(tmp50),.c(tmp25));
			qadd2 Add_u27(.a(tmp52),.b(tmp54),.c(tmp27));
			qadd2 Add_u29(.a(tmp56),.b(tmp58),.c(tmp29));
			qadd2 Add_u31(.a(tmp60),.b(tmp62),.c(tmp31));

			qadd2 Add_u33(.a(ff1),.b(ff3),.c(tmp33));
			qadd2 Add_u35(.a(ff5),.b(ff7),.c(tmp35));
			qadd2 Add_u37(.a(ff9),.b(ff11),.c(tmp37));
			qadd2 Add_u39(.a(ff13),.b(ff15),.c(tmp39));
			qadd2 Add_u41(.a(ff17),.b(ff19),.c(tmp41));
			qadd2 Add_u43(.a(ff21),.b(ff23),.c(tmp43));
			qadd2 Add_u45(.a(ff25),.b(ff27),.c(tmp45));
			qadd2 Add_u47(.a(ff29),.b(ff31),.c(tmp47));

			qadd2 Add_u49(.a(tmp33),.b(tmp35),.c(tmp49));
			qadd2 Add_u51(.a(tmp37),.b(tmp39),.c(tmp51));
			qadd2 Add_u53(.a(tmp41),.b(tmp43),.c(tmp53));
			qadd2 Add_u55(.a(tmp45),.b(tmp47),.c(tmp55));

			qadd2 Add_u57(.a(tmp49),.b(tmp51),.c(tmp57));
			qadd2 Add_u59(.a(tmp53),.b(tmp55),.c(tmp59));

			qadd2 Add_u61(.a(tmp57),.b(tmp59),.c(tmp61));
			
			 /*qadd #(12,16) Add_u1(.a(tmp0),.b(tmp2),.c(tmp1));
			 qadd #(12,16) Add_u3(.a(tmp4),.b(tmp6),.c(tmp3));
			// qadd #(12,16) Add_u5(.a(tmp8),.b(tmp1),.c(tmp5));
 			 qadd #(12,16) Add_u7(.a(tmp1),.b(tmp3),.c(tmp7));*/
									
  
endmodule



 
module vecmat_mul_x #(parameter varraysize=1600,vectwidth=100) //,matsize=64)   // varraysize=1024 vectwidth=64,matsize=4096
(
 input clk,reset,
 input [varraysize-1:0] data,
 input [varraysize-1:0] W,
 //output reg [15:0] data_out
 output [varraysize-1:0] tmp
 );

 
// wire overflow [vectwidth-1:0];  

 wire [15:0] matrix_output[vectwidth-1:0];  
 //wire [15:0] tmp[vectwidth-1:0];


 reg [varraysize-1:0] vector;
 reg [varraysize-1:0] matrix;

 
   
 always @(posedge clk) begin
	if(~reset) begin
		vector <= data;
		matrix <= W;			
       	                         
	   	///count <= count+1;
		//data_out <= tmp97;
	end   
 end      


 /*genvar j;
 generate
	 for(j=0;j<100;j=j+1) begin
   			signedmul mult_u0(.a(vector[j*16+:16]),.b(matrix[j*16+:16]),.c(tmp[j*16+:16]));
	 end
 endgenerate*/
 
 	 signedmul mult_u0(.a(vector[0*16+:16]),.b(matrix[0*16+:16]),.c(tmp[0*16+:16]));
	signedmul mult_u1(.a(vector[1*16+:16]),.b(matrix[1*16+:16]),.c(tmp[1*16+:16]));
	signedmul mult_u2(.a(vector[2*16+:16]),.b(matrix[2*16+:16]),.c(tmp[2*16+:16]));
	signedmul mult_u3(.a(vector[3*16+:16]),.b(matrix[3*16+:16]),.c(tmp[3*16+:16]));
	signedmul mult_u4(.a(vector[4*16+:16]),.b(matrix[4*16+:16]),.c(tmp[4*16+:16]));
	signedmul mult_u5(.a(vector[5*16+:16]),.b(matrix[5*16+:16]),.c(tmp[5*16+:16]));
	signedmul mult_u6(.a(vector[6*16+:16]),.b(matrix[6*16+:16]),.c(tmp[6*16+:16]));
	signedmul mult_u7(.a(vector[7*16+:16]),.b(matrix[7*16+:16]),.c(tmp[7*16+:16]));
	signedmul mult_u8(.a(vector[8*16+:16]),.b(matrix[8*16+:16]),.c(tmp[8*16+:16]));
	signedmul mult_u9(.a(vector[9*16+:16]),.b(matrix[9*16+:16]),.c(tmp[9*16+:16]));
	signedmul mult_u10(.a(vector[10*16+:16]),.b(matrix[10*16+:16]),.c(tmp[10*16+:16]));
	signedmul mult_u11(.a(vector[11*16+:16]),.b(matrix[11*16+:16]),.c(tmp[11*16+:16]));
	signedmul mult_u12(.a(vector[12*16+:16]),.b(matrix[12*16+:16]),.c(tmp[12*16+:16]));
	signedmul mult_u13(.a(vector[13*16+:16]),.b(matrix[13*16+:16]),.c(tmp[13*16+:16]));
	signedmul mult_u14(.a(vector[14*16+:16]),.b(matrix[14*16+:16]),.c(tmp[14*16+:16]));
	signedmul mult_u15(.a(vector[15*16+:16]),.b(matrix[15*16+:16]),.c(tmp[15*16+:16]));
	signedmul mult_u16(.a(vector[16*16+:16]),.b(matrix[16*16+:16]),.c(tmp[16*16+:16]));
	signedmul mult_u17(.a(vector[17*16+:16]),.b(matrix[17*16+:16]),.c(tmp[17*16+:16]));
	signedmul mult_u18(.a(vector[18*16+:16]),.b(matrix[18*16+:16]),.c(tmp[18*16+:16]));
	signedmul mult_u19(.a(vector[19*16+:16]),.b(matrix[19*16+:16]),.c(tmp[19*16+:16]));
	signedmul mult_u20(.a(vector[20*16+:16]),.b(matrix[20*16+:16]),.c(tmp[20*16+:16]));
	signedmul mult_u21(.a(vector[21*16+:16]),.b(matrix[21*16+:16]),.c(tmp[21*16+:16]));
	signedmul mult_u22(.a(vector[22*16+:16]),.b(matrix[22*16+:16]),.c(tmp[22*16+:16]));
	signedmul mult_u23(.a(vector[23*16+:16]),.b(matrix[23*16+:16]),.c(tmp[23*16+:16]));
	signedmul mult_u24(.a(vector[24*16+:16]),.b(matrix[24*16+:16]),.c(tmp[24*16+:16]));
	signedmul mult_u25(.a(vector[25*16+:16]),.b(matrix[25*16+:16]),.c(tmp[25*16+:16]));
	signedmul mult_u26(.a(vector[26*16+:16]),.b(matrix[26*16+:16]),.c(tmp[26*16+:16]));
	signedmul mult_u27(.a(vector[27*16+:16]),.b(matrix[27*16+:16]),.c(tmp[27*16+:16]));
	signedmul mult_u28(.a(vector[28*16+:16]),.b(matrix[28*16+:16]),.c(tmp[28*16+:16]));
	signedmul mult_u29(.a(vector[29*16+:16]),.b(matrix[29*16+:16]),.c(tmp[29*16+:16]));
	signedmul mult_u30(.a(vector[30*16+:16]),.b(matrix[30*16+:16]),.c(tmp[30*16+:16]));
	signedmul mult_u31(.a(vector[31*16+:16]),.b(matrix[31*16+:16]),.c(tmp[31*16+:16]));
	signedmul mult_u32(.a(vector[32*16+:16]),.b(matrix[32*16+:16]),.c(tmp[32*16+:16]));
	signedmul mult_u33(.a(vector[33*16+:16]),.b(matrix[33*16+:16]),.c(tmp[33*16+:16]));
	signedmul mult_u34(.a(vector[34*16+:16]),.b(matrix[34*16+:16]),.c(tmp[34*16+:16]));
	signedmul mult_u35(.a(vector[35*16+:16]),.b(matrix[35*16+:16]),.c(tmp[35*16+:16]));
	signedmul mult_u36(.a(vector[36*16+:16]),.b(matrix[36*16+:16]),.c(tmp[36*16+:16]));
	signedmul mult_u37(.a(vector[37*16+:16]),.b(matrix[37*16+:16]),.c(tmp[37*16+:16]));
	signedmul mult_u38(.a(vector[38*16+:16]),.b(matrix[38*16+:16]),.c(tmp[38*16+:16]));
	signedmul mult_u39(.a(vector[39*16+:16]),.b(matrix[39*16+:16]),.c(tmp[39*16+:16]));
	signedmul mult_u40(.a(vector[40*16+:16]),.b(matrix[40*16+:16]),.c(tmp[40*16+:16]));
	signedmul mult_u41(.a(vector[41*16+:16]),.b(matrix[41*16+:16]),.c(tmp[41*16+:16]));
	signedmul mult_u42(.a(vector[42*16+:16]),.b(matrix[42*16+:16]),.c(tmp[42*16+:16]));
	signedmul mult_u43(.a(vector[43*16+:16]),.b(matrix[43*16+:16]),.c(tmp[43*16+:16]));
	signedmul mult_u44(.a(vector[44*16+:16]),.b(matrix[44*16+:16]),.c(tmp[44*16+:16]));
	signedmul mult_u45(.a(vector[45*16+:16]),.b(matrix[45*16+:16]),.c(tmp[45*16+:16]));
	signedmul mult_u46(.a(vector[46*16+:16]),.b(matrix[46*16+:16]),.c(tmp[46*16+:16]));
	signedmul mult_u47(.a(vector[47*16+:16]),.b(matrix[47*16+:16]),.c(tmp[47*16+:16]));
	signedmul mult_u48(.a(vector[48*16+:16]),.b(matrix[48*16+:16]),.c(tmp[48*16+:16]));
	signedmul mult_u49(.a(vector[49*16+:16]),.b(matrix[49*16+:16]),.c(tmp[49*16+:16]));
	signedmul mult_u50(.a(vector[50*16+:16]),.b(matrix[50*16+:16]),.c(tmp[50*16+:16]));
	signedmul mult_u51(.a(vector[51*16+:16]),.b(matrix[51*16+:16]),.c(tmp[51*16+:16]));
	signedmul mult_u52(.a(vector[52*16+:16]),.b(matrix[52*16+:16]),.c(tmp[52*16+:16]));
	signedmul mult_u53(.a(vector[53*16+:16]),.b(matrix[53*16+:16]),.c(tmp[53*16+:16]));
	signedmul mult_u54(.a(vector[54*16+:16]),.b(matrix[54*16+:16]),.c(tmp[54*16+:16]));
	signedmul mult_u55(.a(vector[55*16+:16]),.b(matrix[55*16+:16]),.c(tmp[55*16+:16]));
	signedmul mult_u56(.a(vector[56*16+:16]),.b(matrix[56*16+:16]),.c(tmp[56*16+:16]));
	signedmul mult_u57(.a(vector[57*16+:16]),.b(matrix[57*16+:16]),.c(tmp[57*16+:16]));
	signedmul mult_u58(.a(vector[58*16+:16]),.b(matrix[58*16+:16]),.c(tmp[58*16+:16]));
	signedmul mult_u59(.a(vector[59*16+:16]),.b(matrix[59*16+:16]),.c(tmp[59*16+:16]));
	signedmul mult_u60(.a(vector[60*16+:16]),.b(matrix[60*16+:16]),.c(tmp[60*16+:16]));
	signedmul mult_u61(.a(vector[61*16+:16]),.b(matrix[61*16+:16]),.c(tmp[61*16+:16]));
	signedmul mult_u62(.a(vector[62*16+:16]),.b(matrix[62*16+:16]),.c(tmp[62*16+:16]));
	signedmul mult_u63(.a(vector[63*16+:16]),.b(matrix[63*16+:16]),.c(tmp[63*16+:16]));
	signedmul mult_u64(.a(vector[64*16+:16]),.b(matrix[64*16+:16]),.c(tmp[64*16+:16]));
	signedmul mult_u65(.a(vector[65*16+:16]),.b(matrix[65*16+:16]),.c(tmp[65*16+:16]));
	signedmul mult_u66(.a(vector[66*16+:16]),.b(matrix[66*16+:16]),.c(tmp[66*16+:16]));
	signedmul mult_u67(.a(vector[67*16+:16]),.b(matrix[67*16+:16]),.c(tmp[67*16+:16]));
	signedmul mult_u68(.a(vector[68*16+:16]),.b(matrix[68*16+:16]),.c(tmp[68*16+:16]));
	signedmul mult_u69(.a(vector[69*16+:16]),.b(matrix[69*16+:16]),.c(tmp[69*16+:16]));
	signedmul mult_u70(.a(vector[70*16+:16]),.b(matrix[70*16+:16]),.c(tmp[70*16+:16]));
	signedmul mult_u71(.a(vector[71*16+:16]),.b(matrix[71*16+:16]),.c(tmp[71*16+:16]));
	signedmul mult_u72(.a(vector[72*16+:16]),.b(matrix[72*16+:16]),.c(tmp[72*16+:16]));
	signedmul mult_u73(.a(vector[73*16+:16]),.b(matrix[73*16+:16]),.c(tmp[73*16+:16]));
	signedmul mult_u74(.a(vector[74*16+:16]),.b(matrix[74*16+:16]),.c(tmp[74*16+:16]));
	signedmul mult_u75(.a(vector[75*16+:16]),.b(matrix[75*16+:16]),.c(tmp[75*16+:16]));
	signedmul mult_u76(.a(vector[76*16+:16]),.b(matrix[76*16+:16]),.c(tmp[76*16+:16]));
	signedmul mult_u77(.a(vector[77*16+:16]),.b(matrix[77*16+:16]),.c(tmp[77*16+:16]));
	signedmul mult_u78(.a(vector[78*16+:16]),.b(matrix[78*16+:16]),.c(tmp[78*16+:16]));
	signedmul mult_u79(.a(vector[79*16+:16]),.b(matrix[79*16+:16]),.c(tmp[79*16+:16]));
	signedmul mult_u80(.a(vector[80*16+:16]),.b(matrix[80*16+:16]),.c(tmp[80*16+:16]));
	signedmul mult_u81(.a(vector[81*16+:16]),.b(matrix[81*16+:16]),.c(tmp[81*16+:16]));
	signedmul mult_u82(.a(vector[82*16+:16]),.b(matrix[82*16+:16]),.c(tmp[82*16+:16]));
	signedmul mult_u83(.a(vector[83*16+:16]),.b(matrix[83*16+:16]),.c(tmp[83*16+:16]));
	signedmul mult_u84(.a(vector[84*16+:16]),.b(matrix[84*16+:16]),.c(tmp[84*16+:16]));
	signedmul mult_u85(.a(vector[85*16+:16]),.b(matrix[85*16+:16]),.c(tmp[85*16+:16]));
	signedmul mult_u86(.a(vector[86*16+:16]),.b(matrix[86*16+:16]),.c(tmp[86*16+:16]));
	signedmul mult_u87(.a(vector[87*16+:16]),.b(matrix[87*16+:16]),.c(tmp[87*16+:16]));
	signedmul mult_u88(.a(vector[88*16+:16]),.b(matrix[88*16+:16]),.c(tmp[88*16+:16]));
	signedmul mult_u89(.a(vector[89*16+:16]),.b(matrix[89*16+:16]),.c(tmp[89*16+:16]));
	signedmul mult_u90(.a(vector[90*16+:16]),.b(matrix[90*16+:16]),.c(tmp[90*16+:16]));
	signedmul mult_u91(.a(vector[91*16+:16]),.b(matrix[91*16+:16]),.c(tmp[91*16+:16]));
	signedmul mult_u92(.a(vector[92*16+:16]),.b(matrix[92*16+:16]),.c(tmp[92*16+:16]));
	signedmul mult_u93(.a(vector[93*16+:16]),.b(matrix[93*16+:16]),.c(tmp[93*16+:16]));
	signedmul mult_u94(.a(vector[94*16+:16]),.b(matrix[94*16+:16]),.c(tmp[94*16+:16]));
	signedmul mult_u95(.a(vector[95*16+:16]),.b(matrix[95*16+:16]),.c(tmp[95*16+:16]));
	signedmul mult_u96(.a(vector[96*16+:16]),.b(matrix[96*16+:16]),.c(tmp[96*16+:16]));
	signedmul mult_u97(.a(vector[97*16+:16]),.b(matrix[97*16+:16]),.c(tmp[97*16+:16]));
	signedmul mult_u98(.a(vector[98*16+:16]),.b(matrix[98*16+:16]),.c(tmp[98*16+:16]));
	signedmul mult_u99(.a(vector[99*16+:16]),.b(matrix[99*16+:16]),.c(tmp[99*16+:16]));
	
 endmodule

 module vecmat_add_x #(parameter varraysize=1600,vectwidth=100) 
 (
 input clk,reset,
 input [varraysize-1:0] mulout,
 output reg [15:0] data_out
 );
          
  wire [15:0] tmp0, tmp1 ,tmp2 ,tmp3 ,tmp4 ,tmp5 ,tmp6 ,tmp7 ,tmp8 ,tmp9 ,tmp10 ,tmp11 ,tmp12 ,tmp13 ,tmp14 ,tmp15 ,tmp16 ,tmp17 ,tmp18 ,tmp19 ,tmp20 ,tmp21 ,tmp22 ,tmp23 ,tmp24 ,tmp25 ,tmp26 ,tmp27 ,tmp28 ,tmp29 ,tmp30 ,tmp31 ,tmp32 ,tmp33 ,tmp34 ,tmp35 ,tmp36 ,tmp37 ,tmp38 ,tmp39 ,tmp40 ,tmp41 ,tmp42 ,tmp43 ,tmp44 ,tmp45 ,tmp46 ,tmp47 ,tmp48 ,tmp49 ,tmp50,tmp51 ,tmp52 ,tmp53,tmp54 ,tmp55 ,tmp56 ,tmp57 ,tmp58,tmp59 ,tmp60 ,tmp61 ,tmp62 ,tmp63 ,tmp64 ,tmp65 ; 
 wire [15:0] tmp66 ,tmp67 ,tmp68 ,tmp69 ,tmp70 ,tmp71 ,tmp72 ,tmp73 ,tmp74 ,tmp75 ,tmp76 ,tmp77 ,tmp78 ,tmp79 ,tmp80 ,tmp81 ,tmp82 ,tmp83 ,tmp84, tmp85 ,tmp86, tmp87,tmp88 ,tmp89 ,tmp90 ,tmp91 ,tmp92 ,tmp93 ,tmp94 ,tmp95, tmp96, tmp97, tmp98, tmp99;
 reg[31:0] i;

 reg [15:0] ff49,ff51,ff53,ff55,ff57,ff59,ff61,ff63,ff65,ff67,ff69,ff71,ff73;

 always @(posedge clk) begin
	if(~reset) begin	
		data_out <= tmp97;
	//adding a flop pipeline stage
		ff49 <= tmp49;
		ff51 <= tmp51;
		ff53 <= tmp53;
		ff55 <= tmp55;
		ff57 <= tmp57;	
		ff59 <= tmp59;
		ff61 <= tmp61;
		ff63 <= tmp63;
		ff65 <= tmp65;
		ff67 <= tmp67;
		ff69 <= tmp69;
		ff71 <= tmp71;
		ff73 <= tmp73;


	end   
 end     

		qadd2 Add_u0(.a(mulout[16*0+:16]),.b(mulout[16*1+:16]),.c(tmp0));
		qadd2 Add_u2(.a(mulout[16*2+:16]),.b(mulout[16*3+:16]),.c(tmp2));
		qadd2 Add_u4(.a(mulout[16*4+:16]),.b(mulout[16*5+:16]),.c(tmp4));
		qadd2 Add_u6(.a(mulout[16*6+:16]),.b(mulout[16*7+:16]),.c(tmp6));
		qadd2 Add_u8(.a(mulout[16*8+:16]),.b(mulout[16*9+:16]),.c(tmp8));
		qadd2 Add_u10(.a(mulout[16*10+:16]),.b(mulout[16*11+:16]),.c(tmp10));
		qadd2 Add_u12(.a(mulout[16*12+:16]),.b(mulout[16*13+:16]),.c(tmp12));
		qadd2 Add_u14(.a(mulout[16*14+:16]),.b(mulout[16*15+:16]),.c(tmp14));
		qadd2 Add_u16(.a(mulout[16*16+:16]),.b(mulout[16*17+:16]),.c(tmp16));
		qadd2 Add_u18(.a(mulout[16*18+:16]),.b(mulout[16*19+:16]),.c(tmp18));
		qadd2 Add_u20(.a(mulout[16*20+:16]),.b(mulout[16*21+:16]),.c(tmp20));
		qadd2 Add_u22(.a(mulout[16*22+:16]),.b(mulout[16*23+:16]),.c(tmp22));
		qadd2 Add_u24(.a(mulout[16*24+:16]),.b(mulout[16*25+:16]),.c(tmp24));
		qadd2 Add_u26(.a(mulout[16*26+:16]),.b(mulout[16*27+:16]),.c(tmp26));
		qadd2 Add_u28(.a(mulout[16*28+:16]),.b(mulout[16*29+:16]),.c(tmp28));
		qadd2 Add_u30(.a(mulout[16*30+:16]),.b(mulout[16*31+:16]),.c(tmp30));
		qadd2 Add_u32(.a(mulout[16*32+:16]),.b(mulout[16*33+:16]),.c(tmp32));
		qadd2 Add_u34(.a(mulout[16*34+:16]),.b(mulout[16*35+:16]),.c(tmp34));
		qadd2 Add_u36(.a(mulout[16*36+:16]),.b(mulout[16*37+:16]),.c(tmp36));
		qadd2 Add_u38(.a(mulout[16*38+:16]),.b(mulout[16*39+:16]),.c(tmp38));
		qadd2 Add_u40(.a(mulout[16*40+:16]),.b(mulout[16*41+:16]),.c(tmp40));
		qadd2 Add_u42(.a(mulout[16*42+:16]),.b(mulout[16*43+:16]),.c(tmp42));
		qadd2 Add_u44(.a(mulout[16*44+:16]),.b(mulout[16*45+:16]),.c(tmp44));
		qadd2 Add_u46(.a(mulout[16*46+:16]),.b(mulout[16*47+:16]),.c(tmp46));
		qadd2 Add_u48(.a(mulout[16*48+:16]),.b(mulout[16*49+:16]),.c(tmp48));
		qadd2 Add_u50(.a(mulout[16*50+:16]),.b(mulout[16*51+:16]),.c(tmp50));
		qadd2 Add_u52(.a(mulout[16*52+:16]),.b(mulout[16*53+:16]),.c(tmp52));
		qadd2 Add_u54(.a(mulout[16*54+:16]),.b(mulout[16*55+:16]),.c(tmp54));
		qadd2 Add_u56(.a(mulout[16*56+:16]),.b(mulout[16*57+:16]),.c(tmp56));
		qadd2 Add_u58(.a(mulout[16*58+:16]),.b(mulout[16*59+:16]),.c(tmp58));
		qadd2 Add_u60(.a(mulout[16*60+:16]),.b(mulout[16*61+:16]),.c(tmp60));
		qadd2 Add_u62(.a(mulout[16*62+:16]),.b(mulout[16*63+:16]),.c(tmp62));
		qadd2 Add_u64(.a(mulout[16*64+:16]),.b(mulout[16*65+:16]),.c(tmp64));
		qadd2 Add_u66(.a(mulout[16*66+:16]),.b(mulout[16*67+:16]),.c(tmp66));
		qadd2 Add_u68(.a(mulout[16*68+:16]),.b(mulout[16*69+:16]),.c(tmp68));
		qadd2 Add_u70(.a(mulout[16*70+:16]),.b(mulout[16*71+:16]),.c(tmp70));
		qadd2 Add_u72(.a(mulout[16*72+:16]),.b(mulout[16*73+:16]),.c(tmp72));
		qadd2 Add_u74(.a(mulout[16*74+:16]),.b(mulout[16*75+:16]),.c(tmp74));
		qadd2 Add_u76(.a(mulout[16*76+:16]),.b(mulout[16*77+:16]),.c(tmp76));
		qadd2 Add_u78(.a(mulout[16*78+:16]),.b(mulout[16*79+:16]),.c(tmp78));
		qadd2 Add_u80(.a(mulout[16*80+:16]),.b(mulout[16*81+:16]),.c(tmp80));
		qadd2 Add_u82(.a(mulout[16*82+:16]),.b(mulout[16*83+:16]),.c(tmp82));
		qadd2 Add_u84(.a(mulout[16*84+:16]),.b(mulout[16*85+:16]),.c(tmp84));
		qadd2 Add_u86(.a(mulout[16*86+:16]),.b(mulout[16*87+:16]),.c(tmp86));
		qadd2 Add_u88(.a(mulout[16*88+:16]),.b(mulout[16*89+:16]),.c(tmp88));
		qadd2 Add_u90(.a(mulout[16*90+:16]),.b(mulout[16*91+:16]),.c(tmp90));
		qadd2 Add_u92(.a(mulout[16*92+:16]),.b(mulout[16*93+:16]),.c(tmp92));
		qadd2 Add_u94(.a(mulout[16*94+:16]),.b(mulout[16*95+:16]),.c(tmp94));
		qadd2 Add_u96(.a(mulout[16*96+:16]),.b(mulout[16*97+:16]),.c(tmp96));
		qadd2 Add_u98(.a(mulout[16*98+:16]),.b(mulout[16*99+:16]),.c(tmp98));
		
		 
			qadd2 Add_u1(.a(tmp0),.b(tmp2),.c(tmp1));
			qadd2 Add_u3(.a(tmp4),.b(tmp6),.c(tmp3));
			qadd2 Add_u5(.a(tmp8),.b(tmp10),.c(tmp5));
			qadd2 Add_u7(.a(tmp12),.b(tmp14),.c(tmp7));
			qadd2 Add_u9(.a(tmp16),.b(tmp18),.c(tmp9));
			qadd2 Add_u11(.a(tmp20),.b(tmp22),.c(tmp11));
			qadd2 Add_u13(.a(tmp24),.b(tmp26),.c(tmp13));
			qadd2 Add_u15(.a(tmp28),.b(tmp30),.c(tmp15));
			qadd2 Add_u17(.a(tmp32),.b(tmp34),.c(tmp17));
			qadd2 Add_u19(.a(tmp36),.b(tmp38),.c(tmp19));
			qadd2 Add_u21(.a(tmp40),.b(tmp42),.c(tmp21));
			qadd2 Add_u23(.a(tmp44),.b(tmp46),.c(tmp23));
			qadd2 Add_u25(.a(tmp48),.b(tmp50),.c(tmp25));
			qadd2 Add_u27(.a(tmp52),.b(tmp54),.c(tmp27));
			qadd2 Add_u29(.a(tmp56),.b(tmp58),.c(tmp29));
			qadd2 Add_u31(.a(tmp60),.b(tmp62),.c(tmp31));
			qadd2 Add_u33(.a(tmp64),.b(tmp66),.c(tmp33));
			qadd2 Add_u35(.a(tmp68),.b(tmp70),.c(tmp35));
			qadd2 Add_u37(.a(tmp72),.b(tmp74),.c(tmp37));
			qadd2 Add_u39(.a(tmp76),.b(tmp78),.c(tmp39));
			qadd2 Add_u41(.a(tmp80),.b(tmp82),.c(tmp41));
			qadd2 Add_u43(.a(tmp84),.b(tmp86),.c(tmp43));
			qadd2 Add_u45(.a(tmp88),.b(tmp90),.c(tmp45));
			qadd2 Add_u47(.a(tmp92),.b(tmp94),.c(tmp47));
			qadd2 Add_u49(.a(tmp96),.b(tmp98),.c(tmp49));
						
			qadd2 Add_u51(.a(tmp1),.b(tmp3),.c(tmp51));
			qadd2 Add_u53(.a(tmp5),.b(tmp7),.c(tmp53));
			qadd2 Add_u55(.a(tmp9),.b(tmp11),.c(tmp55));
			qadd2 Add_u57(.a(tmp13),.b(tmp15),.c(tmp57));
			qadd2 Add_u59(.a(tmp17),.b(tmp19),.c(tmp59));
			qadd2 Add_u61(.a(tmp21),.b(tmp23),.c(tmp61));
			qadd2 Add_u63(.a(tmp25),.b(tmp27),.c(tmp63));
			qadd2 Add_u65(.a(tmp29),.b(tmp31),.c(tmp65));
			qadd2 Add_u67(.a(tmp33),.b(tmp35),.c(tmp67));
			qadd2 Add_u69(.a(tmp37),.b(tmp39),.c(tmp69));
			qadd2 Add_u71(.a(tmp41),.b(tmp43),.c(tmp71));
			qadd2 Add_u73(.a(tmp45),.b(tmp47),.c(tmp73));
			
			qadd2 Add_u75(.a(ff49),.b(ff51),.c(tmp75));
			qadd2 Add_u77(.a(ff53),.b(ff55),.c(tmp77));
			qadd2 Add_u79(.a(ff57),.b(ff59),.c(tmp79));
			qadd2 Add_u81(.a(ff61),.b(ff63),.c(tmp81));
			qadd2 Add_u83(.a(ff65),.b(ff67),.c(tmp83));
			qadd2 Add_u85(.a(ff69),.b(ff71),.c(tmp85));

			qadd2 Add_u87(.a(ff73),.b(tmp75),.c(tmp87));
			qadd2 Add_u89(.a(tmp77),.b(tmp79),.c(tmp89));
			qadd2 Add_u91(.a(tmp81),.b(tmp83),.c(tmp91));

			qadd2 Add_u93(.a(tmp85),.b(tmp87),.c(tmp93));
			qadd2 Add_u95(.a(tmp89),.b(tmp91),.c(tmp95));

			qadd2 Add_u97(.a(tmp93),.b(tmp95),.c(tmp97));
			
			
			/* qadd #(12,16) Add_u1(.a(tmp0),.b(tmp2),.c(tmp1));
			 qadd #(12,16) Add_u3(.a(tmp4),.b(tmp6),.c(tmp3));
			 qadd #(12,16) Add_u5(.a(tmp8),.b(tmp1),.c(tmp5));
 			 qadd #(12,16) Add_u7(.a(tmp5),.b(tmp3),.c(tmp7));*/
									
	   
endmodule

module signedmul(
  input [15:0] a,
  input [15:0] b,
  output [15:0] c
);

wire [31:0] result;
wire [15:0] a_new;
wire [15:0] b_new;

assign c = (b[15]==a[15])?result[26:12]:(~result[26:12]+1'b1);
assign a_new = a[15]?(~a + 1'b1):a;
assign b_new = b[15]?(~b + 1'b1):b;
assign result = a_new*b_new;


endmodule



module qadd2(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


endmodule


module sigmoid(
input [15:0] x,
output [15:0] sig_out
);

reg [15:0] lut;
reg [5:0] address;

assign sig_out = lut;

always @(address)
begin

       case(address)
       6'd0: lut = 16'b0000000000101101; //sig(-4.5)
       6'd1: lut = 16'b0000000000110110; //sig(-4.3)
       6'd2: lut = 16'b0000000001000010; //sig(-4.1)
       6'd3: lut = 16'b0000000001010001; //sig(-3.9)
       6'd4:  lut = 16'b0000000001100010; //sig(-3.7)
       6'd5 :  lut = 16'b0000000001111000; //sig(-3.5)
       6'd6 :  lut= 16'b0000000010010001; //sig(-3.3)
       6'd7 :  lut= 16'b0000000010110000; //sig(-3.1)
       6'd8:  lut= 16'b0000000011010101; //sig(-2.9)
       6'd9 :  lut= 16'b0000000100000010; //sig(-2.7)
       6'd10 :  lut= 16'b0000000100110110; //sig(-2.5)
       6'd11 :  lut= 16'b0000000101110101; //sig(-2.3)
       6'd12 :  lut= 16'b0000000110111110; //sig(-2.1)
       6'd13 :  lut= 16'b0000001000010100; //sig(-1.9)
       6'd14 :  lut= 16'b0000001001111000; //sig(-1.7)
       6'd15 :  lut= 16'b0000001011101011; //sig(-1.5)
       6'd16 :  lut= 16'b0000001101101101; //sig(-1.3)
       6'd17:  lut= 16'b0000001111111110; //sig(-1.1) 
       6'd18 :  lut= 16'b0000010010100000; //sig(-0.9)
       6'd19 :  lut= 16'b0000010101001111; //sig(-0.7)
       6'd20 :  lut= 16'b0000011000001010; //sig(-0.5)
       6'd21 :  lut= 16'b0000011011001111; //sig(-0.3)
       6'd22 :  lut= 16'b0000011110011001; //sig(-0.1)
       6'd23 :  lut= 16'b0000100001100110; //sig(0.1)
       6'd24 :  lut= 16'b0000100100110000; //sig(0.3)
       6'd25 :  lut= 16'b0000100111110101; //sig(0.5)
       6'd26 :  lut= 16'b0000101010110000; //sig(0.7)
       6'd27 :  lut= 16'b0000101101100000; //sig(0.9)
       6'd28 :  lut= 16'b0000110000000001; //sig(1.1)
       6'd29 :  lut= 16'b0000110010010010; //sig(1.3)
       6'd30 :  lut= 16'b0000110100010100; //sig(1.5)
       6'd31 :  lut= 16'b0000110110000111; //sig(1.7)
       6'd32 :  lut= 16'b0000110111101011; //sig(1.9)
       6'd33 :  lut= 16'b0000111001000001; //sig(2.1)
       6'd34 :  lut= 16'b0000111010001010; //sig(2.3)
       6'd35 :  lut= 16'b0000111011001001; //sig(2.5)
       6'd36 :  lut= 16'b0000111011111110; //sig(2.7)
       6'd37 :  lut= 16'b0000111100101010; //sig(2.9)
       6'd38 :  lut= 16'b0000111101001111; //sig(3.1)
       6'd39 :  lut= 16'b0000111101101110; //sig(3.3)
       6'd40 :  lut= 16'b0000111110000111; //sig(3.5)
       6'd41 :  lut= 16'b0000111110011101; //sig(3.7)
       6'd42 :  lut= 16'b0000111110101110; //sig(3.9)
       6'd43 :  lut= 16'b0000111110111101; //sig(4.1)
       6'd44 :  lut= 16'b0000111111001001; //sig(4.3)
       6'd45 :  lut= 16'b0000111111010011; //sig(4.5) 
       6'd46 :  lut= 16'b0000111111011011; //sig(4.7) 
       6'd47 :  lut= 16'b0000000000100100; //sig(-4.7)
       6'd48:	lut= 16'b0000000000000000; //0  
       6'd49:	lut= 16'b0001000000000000; //1 
       default: lut=0;
	endcase
end


always@(x)
begin
 
    case({x[15:12]})
	4'b1000:address = 6'd48; 
	4'b1001:address = 6'd48; 
	4'b1010:address = 6'd48; 
	4'b1011:address = 6'd48; 
	4'b1100:address = 6'd48;  
        4'b1101:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // -3
                    begin
                       address = 6'd8;                 
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address = 6'd9;
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address = 6'd10;                                        
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd11;                                                          
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd12;                                    
                    end   
        4'b1110:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // -2
                    begin
                        address =  6'd13;              
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd14;                
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address = 6'd15;                                                         
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd16;                                                                           
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd17;                                                        
                    end 
        4'b1111:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333))  // -1
                    begin
                        address =  6'd18;                
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd19;                                    
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address =  6'd20;                                                                         
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd21;                                                                                                
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd22;                                                                            
                    end 
        4'b0000:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // 0
                    begin
                        address =  6'd23;                
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd24;                
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address =  6'd25;                                                        
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd26;                                                                            
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd27;                                                        
                    end 
        4'b0001:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // 1
                    begin
                        address =  6'd28;                
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd29;                
                    end
                else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address =  6'd30;                                                        
                    end
                else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd31;                                                                            
                    end
                else if(x[11:0] > 12'hccd)
                    begin
                       address =  6'd32;                                                         
                    end 
        4'b0010:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333))  // 2
                    begin
                      address =  6'd33;                  
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                      address =  6'd34;                   
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                       address =  6'd35;                                                          
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                       address =  6'd36;                                                                               
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                       address =  6'd37;                                                          
                    end 
        4'b0011:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // 3
                    begin
                       address =  6'd38;                  
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                      address =  6'd39;                  
                    end
                else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                      address =  6'd40;                                                          
                    end
                else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                      address = 6'd41;                                                                              
                    end
               else if(x[11:0] > 12'hccd)
                    begin
                       address = 6'd42;                                                        
                    end 
	4'b0100:address = 6'd49;  
	4'b0101:address = 6'd49;  
	4'b0110:address = 6'd49;  
	4'b0111:address = 6'd49;  
       /* 4'b0100:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) //4
                    begin
                      address = lut[43];                 
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                       address = lut[44];                 
                    end
                else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                       address = lut[45];                                                   
                    end
                else if(x[11:0] > 12'h99a) 
                    begin
                        address = lut[46];                                                                            
                    end
	4'b0101: address = lut[46];    
	4'b0110: address = lut[46];   
	4'b0111: address = lut[46];  */ 
	/*default:begin
			address = 16'h1000;
		end*/
        endcase

end

endmodule

module tanh(
input [15:0] x,
output [15:0] tanh_out);

reg [15:0] lut;
wire [15:0] x_comp;
reg [15:0] tanh_comp;
//reg [15:0] tanh;
reg [4:0] address;


assign x_comp = x[15]? {1'b0,~(x[14:0])}+1'b1:x; // first take 2's complement if x is negative
assign tanh_out = x[15]?(~lut+1'b1):lut; // take 2's complement of tanh if x was negative

always @(address)
begin
  case(address) 	    
  5'd0:  lut =16'b0000100000000010; //address(0.55)
  5'd1:  lut=16'b0000100100100101; //address(0.65)
  5'd2:  lut=16'b0000101000101001; //address(0.75)
  5'd3:  lut=16'b0000101100001110; //address(0.85)
  5'd4:  lut=16'b0000101111010110; //address(0.95)
  5'd5:  lut=16'b0000110010000010; //address(1.05)
  5'd6:  lut=16'b0000110100010101; //address(1.15)
  5'd7:  lut=16'b0000110110010010; //address(1.25)
  5'd8:  lut=16'b0000110111111100; //address(1.35)
  5'd9:  lut=16'b0000111001010100; //address(1.45)
  5'd10:  lut=16'b0000111010011110; //address(1.55)
  5'd11:  lut=16'b0000111011011100; //address(1.65)
  5'd12:  lut=16'b0000111100001111; //address(1.75)
  5'd13:  lut=16'b0000111100111010; //address(1.85)
  5'd14:  lut=16'b0000111101011101; //address(1.95)
  5'd15:  lut=16'b0000111101111010; //address(2.05)
  5'd16:  lut=16'b0000111110010010; //address(2.15)
  5'd17:  lut=16'b0000111110100110; //address(2.25)
  5'd18:  lut=16'b0000111110110110; //address(2.35)
  5'd19:  lut=16'b0000111111000011; //address(2.45)
  5'd20:  lut=16'b0000111111001110; //address(2.55)
  5'd21:  lut=16'b0000111111101011; //address(3.0)
  5'd22:  lut=16'b0001000000000000; //1
  5'd23:  lut=x_comp;
  default: lut=0;
  endcase
end

always@(x)
begin
  /*if(rst == 0)
        tanh_out = 0;
  else
    begin*/
    // first take 2's complement if x is negative
    /*if(x[15] == 1'b1)
        begin
            x_comp = {1'b0,~(x[14:0])}+1'b1;
        end
    else
        begin
            x_comp = x;
    end*/
    
    // next find the address
   
    if((x_comp >= 16'h0800) && (x_comp < 16'h3000))
    begin
    case(x_comp[15:12])
        4'b0000:begin
                if((x_comp[11:0] >= 16'h800) && (x_comp[11:0] < 16'h99a))
                    address = 5'd0;
                else if((x_comp[11:0] >= 16'h99a) && (x_comp[11:0] < 16'hb33))
                    address = 5'd1;
                else if((x_comp[11:0] >= 16'hb33) && (x_comp[11:0] < 16'hccd))
                    address = 5'd2;
                else if((x_comp[11:0] >= 16'hccd) && (x_comp[11:0] < 16'he66))
                    address = 5'd3;
                else if(x_comp[11:0] >= 16'he66)
                    address = 5'd4;
                end
        4'b0001:begin
                if((x_comp[11:0] >= 16'h000) && (x_comp[11:0] < 16'h19a))
                    address = 5'd5;
                else if((x_comp[11:0] >= 16'h19a) && (x_comp[11:0] < 16'h333))
                    address = 5'd6;
                else if((x_comp[11:0] >= 16'h333) && (x_comp[11:0] < 16'h4cd))
                    address = 5'd7;
                else if((x_comp[11:0] >= 16'h4cd) && (x_comp[11:0] < 16'h666))
                    address = 5'd8;
                else if((x_comp[11:0] >= 16'h666) && (x_comp[11:0] < 16'h800))
                    address = 5'd9;
                else if((x_comp[11:0] >= 16'h800) && (x_comp[11:0] < 16'h99a))
                    address = 5'd10;
                else if((x_comp[11:0] >= 16'h99a) && (x_comp[11:0] < 16'hb33))
                    address = 5'd11;
                else if((x_comp[11:0] >= 16'hb33) && (x_comp[11:0] < 16'hccd))
                    address = 5'd12;
                else if((x_comp[11:0] >= 16'hccd) && (x_comp[11:0] < 16'he66))
                    address = 5'd13;
                else if(x_comp[11:0] >= 16'he66)
                    address = 5'd14;
                end
        4'b0010:begin
                if((x_comp[11:0] >= 16'h000) && (x_comp[11:0] < 16'h19a))
                    address = 5'd15;
                else if((x_comp[11:0] >= 16'h19a) && (x_comp[11:0] < 16'h333))
                    address = 5'd16;
                else if((x_comp[11:0] >= 16'h333) && (x_comp[11:0] < 16'h4cd))
                    address = 5'd17;
                else if((x_comp[11:0] >= 16'h4cd) && (x_comp[11:0] < 16'h666))
                    address = 5'd18;
                else if((x_comp[11:0] >= 16'h666) && (x_comp[11:0] < 16'h800))
                    address = 5'd19;
                else if((x_comp[11:0] >= 16'h800) && (x_comp[11:0] < 16'h99a))
                    address = 5'd20;
                else if(x_comp[11:0] >= 16'h99a)
                    address = 5'd21;
                end
	default: address = 0;
    endcase
    end
    
    else if((x_comp >= 16'h0000) && (x_comp < 16'h0800))
           begin
               address = 5'd23;
           end
    else if(x_comp >= 16'h3000)
           begin
               address = 5'd22;
           end               
   //end
    
end


endmodule
