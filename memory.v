module memory
  #(
    parameter width = 8,
    parameter wordlength = 4,
    parameter addresswidth = 14,
    parameter depth = 2**addresswidth,
    parameter data = "testmem.dat"
    )
   (
    input 		     clk,
    output [width*wordlength-1:0]   dataOut,
    input [addresswidth-1:0] address,
    input 		     writeEnable,
    input [width*wordlength-1:0] 	     dataIn
    );

   reg [width-1:0] 	     memory [depth-1:0];

   initial $readmemh(data, memory);
   //generate code to read and write one word of data and from memory 
   genvar 		     i;
   generate
      for (i = 0; i < wordlength; i = i+1) begin
        always @(posedge clk) begin
          if(writeEnable) begin
             memory[address+wordlength-1-i] <= dataIn[i*width+:width];
          end
        end // always @ (posedge clk)
      assign dataOut[(wordlength-i-1)*width+:width] = memory[address+i];
      end
   endgenerate
   endmodule
