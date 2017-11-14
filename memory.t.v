`include "memory.v"
module programMemoryTestBench
  ();
   wire [31:0]dataOut;
   reg [31:0] dataIn;
   reg 	      writeEnable;
   reg [13:0] address;
   reg 	     Clk;
   reg 	     dutpassed;

   always #10 Clk = !Clk;

   memory dut(
	      .clk(Clk),
	      .dataOut(dataOut),
	      .dataIn(dataIn),
	      .writeEnable(writeEnable),
	      .address(address));

   initial begin
      //setup initial values
      Clk = 0;
      dutpassed = 1;

      //Test Case 0: Read First Instruction
      address = 0;
      #20;//wait for clock
      if(dataOut != 32'hDEADBEEF) begin
        $display("Test Case 0 Failed: first instruction not 0xDEADBEEF, %h",dataOut);
        dutpassed = 0;
      end

      //Test Case 1: Read Second Instruction
      address = 4;
      #20;//wait for clock
      if(dataOut != 32'h00c0ffee) begin
        $display("Test Case 1 Failed: second instruction not 0x00c0ffee");
        dutpassed = 0;
      end

      //Test Case 2: Read Second Instruction
      address = 8;
      #20;//wait for clock
      if(dataOut != 32'h00bada55) begin
        $display("Test Case 2 Failed: third instruction not 0x00bada55");
        dutpassed = 0;
      end

      //Test Case 3: Write and Read
      //Write 0x1337FADE to address 16 and check that value is written
      address = 16;
      writeEnable = 1;
      dataIn = 32'h1337FADE;
      #20;//wait for clock
      if(dataOut != 32'h1337FADE) begin
        $display("Test Case 3 Failed: 0x1337FADE not read from address 16");
        dutpassed = 0;
      end

      $display("DUT Passed");
      $finish();
   end
   always @(negedge dutpassed) begin
      $display("DUT Failed");
      $finish();

   end
endmodule
