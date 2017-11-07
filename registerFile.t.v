`include "registerFile.v"

module registerFileTestBench
  ();
   
  wire [31:0] ReadData1;
  wire [31:0] ReadData2;
   reg [31:0] WriteData;
   reg [6:0]  ReadReg1;
   reg [6:0] ReadReg2;
   reg [6:0] WriteReg;
   reg 	     RegWrite;
   reg 	     Clk;
   reg 	     dutpassed;
   
   always #10 Clk = !Clk;
   
   
   registerFile dut(
		    .ReadRegister1(ReadReg1),
		    .ReadRegister2(ReadReg2),
		    .WriteData(WriteData),
		    .ReadData1(ReadData1),
		    .ReadData2(ReadData2),
		    .WriteRegister(WriteReg),
		    .RegWrite(RegWrite),
		    .Clk(Clk));

   initial begin
      //setup initial values
      Clk = 0;
      dutpassed = 1;

      //Test Case 0: Zero Register
      //Try writing non-zero value to zero register and check that value is still zero
      WriteReg = 0;
      RegWrite = 1;
      WriteData = 50;
      #20;//wait for clock
      ReadReg1 = 0;
      #20;//wait for clock
      if(ReadData1 != 0) begin
	 $display("Test Case 0 Failed: Zero register gave non-zero value");
	 dutpassed = 0;
      end

      //Test Case 1: Write and Read
      //Write 0xDEADBEEF to register 17 and check that value is written
      WriteReg = 17;
      WriteData = 32'hDEADBEEF;
      #20;//wait for clock
      ReadReg2 = 17;
      #20;//wait for clock
      if(ReadData2 != 32'hDEADBEEF) begin
	 $display("Test Case 1 Failed: 0xDEADBEEF not read from register 17");
	 dutpassed = 0;
      end

      //Test Case 2: Check Write Enable
      //Attempt to Write 0x00BADA55 to register 23 and check that value is not written
      RegWrite = 0;
      WriteReg = 23;
      WriteData = 32'h00BADA55;
      #20;
      ReadReg1 = 23;
      #20;
      if(ReadData1 == 32'h00BADA55) begin
	 $display("Test Case 2 Failed: 0x00BADA55 read from register 23");
	 dutpassed = 0;
      end
      
      
      $display("DUT Passed");
      $finish();
      
   end // initial begin

   always @(negedge dutpassed) begin
      $display("DUT Failed");
      $finish();
      
   end

endmodule      
