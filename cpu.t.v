`include "cpu.v"

module cpuTestBench();
  reg clk;
  reg[4:0] regAddr;
  reg[13:0] memAddr;
  wire[31:0] regTest;
  wire[31:0] memTest;
  wire interrupt;
  reg[31:0] currentTest;
  reg[31:0] expectedVals[12];
  reg[31:0] i;
  reg dutPassed = 1;

  cpu dut(clk, regAddr, regTest,
               memAddr, memTest,
               interrupt);
  initial begin
     currentTest = 0;
     expectedVals[0] = 15;
     expectedVals[1] = 20;
     expectedVals[2] = 25;
     expectedVals[3] = 30;
     expectedVals[4] = 35;
     expectedVals[5] = 40;
     expectedVals[6] = 45;
     expectedVals[7] = 9;
     expectedVals[8] = 27;
     expectedVals[9] = 3;
     expectedVals[10] = 1;
     expectedVals[11] = 0;
     clk = 0;
     memAddr = 100;
     regAddr = 25; //t9
     i = 0;
     #5;
     for(i = 0; i<1000; i = i + 1) begin
     clk = 1; #5;
     clk = 0; #5;
     end
     #25;
     if(dutPassed) begin
       $display("DUT passed!");
     end
     $finish();
  end
  always @(posedge interrupt) begin
    if(regTest != expectedVals[currentTest]) begin
      $display("Failed test %d", currentTest);
      $display("%d != %d", regTest, expectedVals[currentTest]);
      dutPassed = 0;
    end
    currentTest = currentTest + 1;
  end

endmodule
