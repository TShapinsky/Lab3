//ops: XOR, ADD, SUB, SLT
`define xorOp 2'b00
`define addOp 2'b01
`define subOp 2'b10
`define sltOp 2'b11

module alu
  #(
  parameter width = 32
  )
  (output signed [width-1:0] out,
   output eq,
   input[1:0] op,
   input signed [width-1:0] A,
   input signed [width-1:0] B);

  wire[width-1:0] outputs[4];

  assign outputs[`xorOp] = A^B;
  assign outputs[`addOp] = A+B;
  assign outputs[`subOp] = A-B;
  assign outputs[`sltOp][0] = A<B;
  assign outputs[`sltOp][width-1:1] = {width{1'b0}};
  assign eq = (A==B);
  assign out[width-1:0] = outputs[op][width-1:0];


endmodule
