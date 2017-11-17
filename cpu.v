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
`define  fnSUB   6'b100010
`define  fnJR    6'b001000
`define  fnSLT   6'b101010
`define  fnSYS   6'b001100

module cpu
#(parameter width = 32, addressWidth = 14, regAddressWidth = 5)
(input clk,
  input[regAddressWidth-1:0] regTestAddr, output reg[width-1:0] regTest,
  input[addressWidth-1:0] memTestAddr, output reg[width-1:0] memTest,
  output reg interrupt);

reg test;

initial begin
  test <= 0;
  interrupt <= 0;
end

wire[width-1:0]         inst_read;
wire[addressWidth-1:0]  inst_addr;

wire[width-1:0]         mem_read;
wire[width-1:0]         mem_write;
reg                     mem_wen;
wire[addressWidth-1:0]  mem_addr;

wire[width-1:0]        alu_a;
wire[width-1:0]        alu_b;
reg[1:0]               alu_op;
wire                   alu_eq;
wire[width-1:0]        alu_out;

wire[width-1:0]           reg_portA;
wire[width-1:0]           reg_portB;
wire[width-1:0]           reg_write;
wire[regAddressWidth-1:0] reg_addrA;
wire[regAddressWidth-1:0] reg_addrB;
wire[regAddressWidth-1:0] reg_addrW;
reg                       reg_wen;

reg[addressWidth-1:0]     pc;
wire[regAddressWidth-1:0] RS;
wire[regAddressWidth-1:0] RT;
wire[regAddressWidth-1:0] RD;
wire[5:0]                 FUNCT;
wire[15:0]                IMM;
wire[25:0]                ADDR;
wire[5:0]                 OP;

wire[width-1:0] imm;
assign imm = {{(width-15){IMM[15]}}, IMM[14:0]};

//possible next values of the program counter for a BNE
wire[addressWidth-1:0] BNE_RESULT_OPTIONS[2];
assign BNE_RESULT_OPTIONS[0] = pc+(imm<<2)+4;
assign BNE_RESULT_OPTIONS[1] = pc+4;
wire[addressWidth-1:0] bneResult;
assign bneResult = BNE_RESULT_OPTIONS[alu_eq];

//possible next values of the program counter
wire[addressWidth-1:0] PC_NEXT_OPTIONS[4];
assign PC_NEXT_OPTIONS[0] = pc+4;                            //Normal execution
assign PC_NEXT_OPTIONS[1] = bneResult;                       //BNE
assign PC_NEXT_OPTIONS[2] = (ADDR<<2);    //J, JAL
assign PC_NEXT_OPTIONS[3] = reg_portA[addressWidth-1:0];     //JR
reg[1:0] pcNextOption;
wire[addressWidth-1:0] pcNext;
assign pcNext = PC_NEXT_OPTIONS[pcNextOption];


//we only address memory based on alue output
wire[addressWidth-1:0] MEM_ADDR_OPTIONS[2];
assign MEM_ADDR_OPTIONS[0] = alu_out;
assign MEM_ADDR_OPTIONS[1] = memTestAddr;
assign mem_addr  = MEM_ADDR_OPTIONS[test]; //LW, SW
assign mem_write = reg_portB;

wire[width-1:0] REG_WRITE_OPTIONS[3];
assign REG_WRITE_OPTIONS[0] = alu_out;  //XORI?, ADDI?, SLT,
assign REG_WRITE_OPTIONS[1] = mem_read; //LW
assign REG_WRITE_OPTIONS[2] = pc+4;     //JAL
reg[1:0] regWriteOption;
assign reg_write = REG_WRITE_OPTIONS[regWriteOption];

wire[regAddressWidth-1:0] REG_WRITE_ADDR_OPTIONS[3];
assign REG_WRITE_ADDR_OPTIONS[0] = RD; //XOR, ADD, SLT
assign REG_WRITE_ADDR_OPTIONS[1] = RT; //LW, XORI, ADDI
assign REG_WRITE_ADDR_OPTIONS[2] = 31; //JAL
reg[1:0] regWriteAddrOption;
assign reg_addrW = REG_WRITE_ADDR_OPTIONS[regWriteAddrOption];

wire[regAddressWidth-1:0] REG_ADDR_A_OPTS[2];
assign REG_ADDR_A_OPTS[0] = RS;
assign REG_ADDR_A_OPTS[1] = regTestAddr;

assign reg_addrA = REG_ADDR_A_OPTS[test];
assign reg_addrB = RT;

assign alu_a = reg_portA;
wire[width-1:0] ALU_B_OPTIONS[2];
assign ALU_B_OPTIONS[0] = reg_portB; //XOR, ADD, SLT
assign ALU_B_OPTIONS[1] = imm;       //XORI, ADDI, LW, SW
reg aluBOption;
assign alu_b = ALU_B_OPTIONS[aluBOption];

assign inst_addr = pc;
assign OP = inst_read[31:26];
assign RS = inst_read[25:21];
assign RT = inst_read[20:16];
assign RD = inst_read[15:11];
assign FUNCT = inst_read[5:0];
assign IMM = inst_read[15:0];
assign ADDR = inst_read[25:0];

always @ (OP or FUNCT) begin
  case(OP)
    `opLW: begin
      alu_op             <= `addOp;
      mem_wen            <= 0;
      reg_wen            <= 1; //write to reg
      regWriteOption     <= 1; //write mem_read to reg
      regWriteAddrOption <= 1; //write to reg[rt]
      aluBOption         <= 1; //use imm
      pcNextOption       <= 0; //normal execution
    end
    `opSW: begin
      alu_op             <= `addOp;
      mem_wen            <= 1; //write to mem
      reg_wen            <= 0;
      aluBOption         <= 1; //use imm
      pcNextOption       <= 0; //normal execution
    end
    `opJ: begin
      mem_wen            <= 0; //write to nothing
      reg_wen            <= 0;
      pcNextOption       <= 2; //jump
    end
    `opJAL: begin
      mem_wen            <= 0;
      reg_wen            <= 1; //write to reg
      regWriteOption     <= 2; //write pc+4 to reg
      regWriteAddrOption <= 2; //write to reg[31]
      pcNextOption       <= 2; //jump
    end
    `opBNE: begin
      mem_wen            <= 0;
      reg_wen            <= 0; //write to nothing
      aluBOption         <= 0; //use rt
      pcNextOption       <= 1; //branch execution
    end
    `opXORI: begin
      alu_op             <= `xorOp;
      mem_wen            <= 0;
      reg_wen            <= 1; //write to reg
      regWriteOption     <= 0; //write alu_out to reg
      regWriteAddrOption <= 1; //write to reg[rt]
      aluBOption         <= 1; //use imm
      pcNextOption       <= 0; //normal execution
    end
    `opADDI: begin
      alu_op             <= `addOp;
      mem_wen            <= 0;
      reg_wen            <= 1; //write to reg
      regWriteOption     <= 0; //write alu_out to reg
      regWriteAddrOption <= 1; //write to reg[rt]
      aluBOption         <= 1; //use imm
      pcNextOption       <= 0; //normal execution
    end
    `opRTYPE: begin
      case(FUNCT)
        `fnADD: begin
          alu_op             <= `addOp;
          mem_wen            <= 0;
          reg_wen            <= 1; //write to reg
          regWriteOption     <= 0; //write alu_out to reg
          regWriteAddrOption <= 0; //write to reg[rb]
          aluBOption         <= 0; //use rb
          pcNextOption       <= 0; //normal execution
        end
        `fnSUB: begin
          alu_op             <= `subOp;
          mem_wen            <= 0;
          reg_wen            <= 1; //write to reg
          regWriteOption     <= 0; //write alu_out to reg
          regWriteAddrOption <= 0; //write to reg[rb]
          aluBOption         <= 0; //use rb
          pcNextOption       <= 0; //normal execution
        end
        `fnJR: begin
          mem_wen            <=0;
          reg_wen            <=0; //write to nothing
          pcNextOption       <=3; //jump to reg[rs]
        end
        `fnSLT: begin
          alu_op             <= `sltOp;
          mem_wen            <= 0;
          reg_wen            <= 1; //write to reg
          regWriteOption     <= 0; //write alu_out to reg
          regWriteAddrOption <= 0; //write to reg[rb]
          aluBOption         <= 0; //use rb
          pcNextOption       <= 0; //normal execution
        end
        `fnSYS: begin
          mem_wen <= 0;
          reg_wen <= 0;
          pcNextOption <= 0;
          test <= 1;
          #1;
          regTest <= reg_portA;
          memTest <= mem_read;
          #1;
          interrupt <= 1;
          #1;
          test <= 0;
          interrupt <= 0;
        end
      endcase
    end
  endcase
end

memory mem(clk, mem_read, mem_addr, mem_wen, mem_write);
memory inst(clk, inst_read, inst_addr, 1'b0, 32'b0);
alu    ex(alu_out, alu_eq, alu_op, alu_a, alu_b);
registerFile regs(reg_portA, reg_portB, reg_write, reg_addrA, reg_addrB, reg_addrW, reg_wen, clk);

always @(posedge clk) begin
  pc <= pcNext;
end

initial begin
  pc = 0;
end

endmodule
