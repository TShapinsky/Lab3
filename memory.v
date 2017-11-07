module memory
  #(
    parameter width = 32,
    parameter addresswidth = 7,
    parameter depth = 2**addresswidth,
    parameter data = "testmem.dat"
    )
   (
    input 		     clk,
    output reg [width-1:0]   dataOut,
    input [addresswidth-1:0] address,
    input 		     writeEnable,
    input [width-1:0] 	     dataIn 	     
    );

   reg [width-1:0] 	     memory [depth-1:0];
   initial $readmemh(data, memory);
   always @(posedge clk) begin
      if(writeEnable) begin
	 memory[address] <= dataIn;
      end
      dataOut <= memory[address];
   end
   endmodule
