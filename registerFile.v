module registerFile
 #(
    parameter width = 32,
    parameter addresswidth = 5,
    parameter depth = 2**addresswidth
    )
  (
   output [width-1:0]   ReadData1,
   output [width-1:0]   ReadData2,
   input [width-1:0] 	    WriteData,
   input [addresswidth-1:0] ReadRegister1,
   input [addresswidth-1:0] ReadRegister2,
   input [addresswidth-1:0] WriteRegister,
   input 		    RegWrite,
   input 		    Clk
   );
   //setup registers
   reg [width-1:0] registers [depth-1:0];
   initial begin
      registers[0][width-1:0] <= 0;
   end

   //do register operations on clock edges
   always @(posedge Clk) begin
      if(RegWrite && WriteRegister != 0) begin
	       registers[WriteRegister] <= WriteData;
      end
   end // always @ (posedge Clk)
   assign ReadData1 = registers[ReadRegister1];
   assign ReadData2 = registers[ReadRegister2];
endmodule
