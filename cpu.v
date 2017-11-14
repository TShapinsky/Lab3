`include "alu.v"
`include "memory.v"
`include "registerFile.v"
`define  opLW    6'b100011
`define  opSW    6'b101011
`define  opJ     6'b000010
`define  opRTYPE 6'b000000
`define  opJAL   6'b000011
`define  opBNE   6'b000101
`define  opXORI  6'b001110
`define  opADDI  6'b001000

`define  fnADD   6'b100000
`define  fnSUB   6'b100011
`define  fnJR    6'b001000

module cpu #(parameter width = 32, addresswidth = 14, regAddressWidth = 5) (input clk);

wire[width-1:0]        inst_read;
wire[addresswidth-1:0] inst_addr;

wire[width-1:0]        mem_read;
reg[width-1:0]         mem_write;
reg                    mem_wen;
reg[addresswidth-1:0]  mem_addr;

reg[width-1:0]        alu_a;
reg[width-1:0]        alu_b;
reg[1:0]              alu_op;
wire                  alu_eq;
wire[width-1:0]       alu_out;

wire[width-1:0]        reg_portA;
wire[width-1:0]        reg_portB;
reg[width-1:0]         reg_write;
reg[regAddressWidth-1:0] reg_addrA;
reg[regAddressWidth-1:0] reg_addrB;
reg[regAddressWidth-1:0] reg_addrW;
reg                      reg_wen;

reg[addresswidth-1:0]     pc;
wire[regAddressWidth-1:0] RS;
wire[regAddressWidth-1:0] RT;
wire[regAddressWidth-1:0] RD;
wire[5:0]                 FUNCT;
wire[15:0]                IMM;
wire[25:0]                ADDR;
wire[5:0]                 OP;

assign inst_addr = pc;
assign OP = inst_read[31:26];
assign RS = inst_read[25:21];
assign RT = inst_read[20:16];
assign RD = inst_read[15:11];
assign FUNCT = inst_read[5:0];
assign IMM = inst_read[15:0];

always @ (posedge clk) begin
  case(OP)
    `opLW: begin
    end
    `opSW: begin
    end
    `opJ: begin
    end
    `opJAL: begin
    end
    `opBNE: begin
    end
    `opXORI: begin
    end
    `opADDI: begin
    end
    `opRTYPE: begin
      case(FUNCT)
        `fnADD: begin
          reg_addrA <= RS;
          reg_addrB <= RT;
          reg_addrW <= RD;
          reg_wen   <= 1;
          reg_write <= alu_out; //bad

          alu_a    <= reg_portA; //bad
          alu_b    <= reg_portB; //bad
          alu_op   <= `subOp;

          mem_wen   <= 0;
        end
        `fnSUB: begin
          reg_addrA <= RS;
          reg_addrB <= RT;
          reg_addrW <= RD;
          reg_wen   <= 1;
          reg_write <= alu_out; //bad

          alu_a    <= reg_portA; //bad
          alu_b    <= reg_portB; //bad
          alu_op   <= `addOp;

          mem_wen   <= 0;
        end
        `fnJR: begin
        end
      endcase
    end
  endcase
end

memory mem(clk, mem_read, mem_addr, mem_wen, mem_write);
memory inst(clk, inst_read, inst_addr, 1'b0, 32'b0);
alu    ex(alu_out, alu_eq, alu_op, alu_a, alu_b);


endmodule
