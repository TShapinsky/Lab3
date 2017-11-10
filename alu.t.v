`include "alu.v"

module aluTestBench();
  reg signed [31:0] A;
  reg signed [31:0] B;
  reg        [1:0]  op;
  wire signed[31:0] out;
  wire eq;
  reg dutPassed;
  alu dut(out, eq, op, A, B);
  initial begin
    dutPassed = 1;
    A = 32'd10;
    B = 32'd14;
    op = `addOp;
    #1;
    if(out != 24 || ^out === 1'bx) begin
      $display("Add test failed");
      dutPassed = 0;
    end

    A = 32'd10;
    B = 32'd14;
    op = `subOp;
    #1;
    if(out != -4 || ^out === 1'bx) begin
      $display("Sub test failed");
      dutPassed = 0;
    end

    A = 32'b00001111000011110000111100001111;
    B = 32'b10101010101010101010101010101010;
    op = `xorOp;
    #1;
    if(out != 32'b10100101101001011010010110100101 || ^out === 1'bx) begin
      $display("Xor test failed");
      dutPassed = 0;
    end

    A = 14;
    B = 32;
    op = `sltOp;
    #1;
    if(out != 1 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("14 >= 32");
      dutPassed = 0;
    end

    A = 32;
    B = 14;
    op = `sltOp;
    #1;
    if(out != 0 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("32 < 14");
      dutPassed = 0;
    end

    A = -14;
    B = -32;
    op = `sltOp;
    #1;
    if(out != 0 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("-14 < -32");
      dutPassed = 0;
    end

    A = -32;
    B = -14;
    op = `sltOp;
    #1;
    if(out != 1 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("-32 >= -14");
      dutPassed = 0;
    end

    A = 14;
    B = -32;
    op = `sltOp;
    #1;
    if(out != 0 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("14 < -32");
      dutPassed = 0;
    end

    A = -32;
    B = 14;
    op = `sltOp;
    #1;
    if(out != 1 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("-32 >= 14");
      dutPassed = 0;
    end

    A = 14;
    B = 14;
    op = `sltOp;
    #1;
    if(out != 0 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("14 < 14");
      dutPassed = 0;
    end

    A = -14;
    B = -14;
    op = `sltOp;
    #1;
    if(out != 0 || ^out === 1'bx) begin
      $display("Slt test failed");
      $display("-14 < -14");
      dutPassed = 0;
    end

    if(!eq || eq === 1'bx) begin
      $display("eq tes failed");
      $display("-14 != -14");
    end
    A = -14;
    B = 14;
    #1;
    if(eq || eq === 1'bx) begin
      $display("eq tes failed");
      $display("-14 == 14");
    end

    if(dutPassed) begin
      $display("DUT passed!");
    end
  end

endmodule
