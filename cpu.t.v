`include "cpu.v"

module cpuTestBench();
  reg clk;
  wire[31:0] regTest;
  wire[31:0] memTest;
  reg[31:0] i;

  cpu dut(clk, regTest, memTest);
  initial begin
     $dumpfile("cpu.vcd");
     $dumpvars(0, cpuTestBench);
     clk = 0;
     i = 0;
     #5;
     for(i = 0; i<1000; i = i + 1) begin
     clk = 1; #5;
     clk = 0; #5;
     end
     #25;
     $finish();
  end

endmodule
