module registerFile
 #(
    parameter width = 32,
    parameter addresswidth = 7,
    parameter depth = 2**addresswidth
    )
  (
   output reg [width-1:0]   ReadData1,
   output reg [width-1:0]   ReadData2,
   input [width-1:0] 	    WriteData,
   input [addresswidth-1:0] ReadRegister1,
   input [addresswidth-1:0] ReadRegister2,
   input [addresswidth-1:0] WriteRegister,
   input 		    RegWrite,
   input 		    Clk
   );
   //setup registers
   reg [width-1:0] registers [depth-1:0];

   //do register operations on clock edges
   always @(posedge Clk) begin
      //check if zero register
      if(ReadRegister1 == 0) begin
	 assign ReadData1 = 0;
      end else begin
	 //read data from registers
	 ReadData1 = registers[ReadRegister1];
      end
      //check if zero register
      if(ReadRegister2 == 0) begin
	 assign ReadData2 = 0;
      end else begin
	 //read data from registers
	 ReadData2 = registers[ReadRegister2];
      end
      //check if write flag is high
      if(RegWrite) begin
	 registers[WriteRegister] <= WriteData;
      end
   end // always @ (posedge Clk)
endmodule
