
/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/


module comparator(
a,
b,
aeb,
aneb,
alb,
aleb,
agb,
ageb,
unordered
);


input [15:0] a;
input [15:0] b;
output aeb;
output aneb;
output alb;
output aleb;
output agb;
output ageb;
output unordered;

wire [16:0] a_RecFN;
wire [16:0] b_RecFN;

//Convert to Recoded representation
fNToRecFN#(5,11) convert_a(.in(a), .out(a_RecFN));  
fNToRecFN#(5,11) convert_b(.in(b), .out(b_RecFN));  

wire [4:0] except_flags;
wire less_than;
wire equal;
wire greater_than;

//Actual conversion module
compareRecFN #(5, 11) compare(
.a(a_RecFN),
.b(b_RecFN),
.signaling(1'b0),
.lt(less_than),
.eq(equal),
.gt(greater_than),
.unordered(unordered),
.exceptionFlags(except_flags)
);

//Result flags
assign aeb = equal;
assign aneb = (~equal);
assign alb = less_than;
assign aleb = (less_than | equal);
assign agb = greater_than;
assign ageb = (greater_than | equal);

endmodule


module reverseFp16 (input [9:0] in, output [9:0] out);

   assign out[0] = in[9];
   assign out[1] = in[8];
   assign out[2] = in[7];
   assign out[3] = in[6];
   assign out[4] = in[5];
   assign out[5] = in[4];
   assign out[6] = in[3];
   assign out[7] = in[2];
   assign out[8] = in[1];
   assign out[9] = in[0];
   // genvar ix;
   // generate
   //     for (ix = 0; ix < width; ix = ix + 1) begin :Bit
   //         assign out[ix] = in[width - 1 - ix];
   //     end
   // endgenerate

endmodule

module fNToRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth - 1):0] in,
        output [(expWidth + sigWidth):0] out
    );

    //localparam normDistWidth = clog2(sigWidth);
    localparam normDistWidth = 4; //Hardcoding for FP16 for now.

    wire sign;
    wire [(expWidth - 1):0] expIn;
    wire [(sigWidth - 2):0] fractIn;
    assign {sign, expIn, fractIn} = in;
    wire isZeroExpIn = (expIn == 0);
    wire isZeroFractIn = (fractIn == 0);
    
   
    wire [(normDistWidth - 1):0] normDist;
    //sigwidth = 11, normDistWidth=4
    countLeadingZerosfp16 #(sigWidth - 1, normDistWidth)  countLeadingZeros(.in(fractIn), .count(normDist)); 
    wire [(sigWidth - 2):0] subnormFract = (fractIn<<normDist)<<1;
    wire [expWidth:0] adjustedExp =
        (isZeroExpIn ? normDist ^ ((1<<(expWidth + 1)) - 1) : expIn)
            + ((1<<(expWidth - 1)) | (isZeroExpIn ? 2 : 1));
    wire isZero = isZeroExpIn && isZeroFractIn;
    wire isSpecial = (adjustedExp[expWidth:(expWidth - 1)] == 'b11);
    
   
    wire [expWidth:0] exp;
    assign exp[expWidth:(expWidth - 2)] =
        isSpecial ? {2'b11, !isZeroFractIn}
            : isZero ? 3'b000 : adjustedExp[expWidth:(expWidth - 2)];
    assign exp[(expWidth - 3):0] = adjustedExp;
    assign out = {sign, exp, isZeroExpIn ? subnormFract : fractIn};

endmodule


module compareRecFN(
  a,
  b,
  signaling,
  lt,
  eq,
  gt,
  unordered,
  exceptionFlags
  );
  parameter expWidth = 3;
  parameter sigWidth = 3;
  
  input [(expWidth + sigWidth):0] a;
  input [(expWidth + sigWidth):0] b;
  input signaling;
  output lt;
  output eq;
  output gt;
  output unordered;
  output [4:0] exceptionFlags;
   

    wire isNaNA, isInfA, isZeroA, signA;
    wire [(expWidth + 1):0] sExpA;
    wire [sigWidth:0] sigA;
    recFNToRawFN#(expWidth, sigWidth)  recFNToRawFN_a(
      .in(a), 
      .isNaN(isNaNA), 
      .isInf(isInfA), 
      .isZero(isZeroA), 
      .sign(signA), 
      .sExp(sExpA), 
      .sig(sigA)
      );
    wire isSigNaNA;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_a(.in(a), .isSigNaN(isSigNaNA));
    wire isNaNB, isInfB, isZeroB, signB;
    wire [(expWidth + 1):0] sExpB;
    wire [sigWidth:0] sigB;
    recFNToRawFN#(expWidth, sigWidth) recFNToRawFN_b(
      .in(b), 
      .isNaN(isNaNB), 
      .isInf(isInfB), 
      .isZero(isZeroB), 
      .sign(signB), 
      .sExp(sExpB), 
      .sig(sigB)
      );
    wire isSigNaNB;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_b(.in(b), .isSigNaN(isSigNaNB));
   
    wire ordered = !isNaNA && !isNaNB;
    wire bothInfs  = isInfA  && isInfB;
    wire bothZeros = isZeroA && isZeroB;
    wire eqExps = (sExpA == sExpB);
    wire common_ltMags = (sExpA < sExpB) || (eqExps && (sigA < sigB));
    wire common_eqMags = eqExps && (sigA == sigB);
    wire ordered_lt =
        !bothZeros
            && ((signA && !signB)
                    || (!bothInfs
                            && ((signA && !common_ltMags && !common_eqMags)
                                    || (!signB && common_ltMags))));
    wire ordered_eq =
        bothZeros || ((signA == signB) && (bothInfs || common_eqMags));
    
    
    wire invalid = isSigNaNA || isSigNaNB || (signaling && !ordered);
    assign lt = ordered && ordered_lt;
    assign eq = ordered && ordered_eq;
    assign gt = ordered && !ordered_lt && !ordered_eq;
    assign unordered = !ordered;
    assign exceptionFlags = {invalid, 4'b0};

endmodule



module recFNToRawFN(
  in,
  isNaN,
  isInf,
  isZero,
  sign,
  sExp,
  sig
  );
  
  parameter expWidth = 3;
  parameter sigWidth = 3;
  
  input [(expWidth + sigWidth):0] in;
  output isNaN;
  output isInf;
  output isZero;
  output sign;
  output [(expWidth + 1):0] sExp;
  output [sigWidth:0] sig;

    
    wire [expWidth:0] exp;
    wire [(sigWidth - 2):0] fract;
    assign {sign, exp, fract} = in;
    wire isSpecial = (exp>>(expWidth - 1) == 'b11);
    
    
    assign isNaN = isSpecial &&  exp[expWidth - 2];
    assign isInf = isSpecial && !exp[expWidth - 2];
    assign isZero = (exp>>(expWidth - 2) == 'b000);
    assign sExp = exp;
    assign sig = {1'b0, !isZero, fract};

endmodule



module  isSigNaNRecFN(in, isSigNaN);

  parameter expWidth = 3;
  parameter sigWidth = 3;
  
  input [(expWidth + sigWidth):0] in;
  output isSigNaN;

    wire isNaN =
        (in[(expWidth + sigWidth - 1):(expWidth + sigWidth - 3)] == 'b111);
    assign isSigNaN = isNaN && !in[sigWidth - 2];

endmodule


module countLeadingZerosfp16 #(parameter inWidth = 10, parameter countWidth = 4) (
    input [(inWidth - 1):0] in, output reg [(countWidth - 1):0] count
    );

  wire [(inWidth - 1):0] reverseIn;
  reverseFp16 reverse_in(in, reverseIn);
  wire [inWidth:0] oneLeastReverseIn =
      {1'b1, reverseIn} & ({1'b0, ~reverseIn} + 1);
		
  always@(*)
    begin
      if (oneLeastReverseIn[10] == 1)
        begin
          count = 4'd10;
        end
      else if (oneLeastReverseIn[9] == 1)
        begin
          count = 4'd9;
        end
      else if (oneLeastReverseIn[8] == 1)
        begin
          count= 4'd8;
        end
      else if (oneLeastReverseIn[7] == 1)
        begin
          count = 4'd7;
        end
      else if (oneLeastReverseIn[6] == 1)
        begin
          count = 4'd6;
        end
      else if (oneLeastReverseIn[5] == 1)
        begin
          count = 4'd5;
        end
      else if (oneLeastReverseIn[4] == 1)
        begin
          count = 4'd4;
        end
      else if (oneLeastReverseIn[3] == 1)
        begin
          count = 4'd3;
        end
      else if (oneLeastReverseIn[2] == 1)
        begin
          count = 4'd2;
        end
      else if (oneLeastReverseIn[1] == 1)
        begin
          count = 4'd1;
        end
      else
        begin
          count = 4'd0;
        end
      end

endmodule

