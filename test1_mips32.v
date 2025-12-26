`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2025 08:44:51 PM
// Design Name: 
// Module Name: test1_mips32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test1_mips32;

    reg clk1, clk2;
    integer k;

    pipe_MIPS32 mips (clk1, clk2);
    
    initial begin
        clk1 = 0;
        clk2 = 0;
        forever begin
            #5 clk1 = 1;  #5 clk1 = 0;
            #5 clk2 = 1;  #5 clk2 = 0;
        end
    end

    initial begin
        for (k = 0; k < 32; k = k + 1)
            mips.Reg[k] = 0;

        mips.Mem[0] = 32'h2801000a;  // ADDI R1, R0, 10
        mips.Mem[1] = 32'h28020014;  // ADDI R2, R0, 20
        mips.Mem[2] = 32'h28030019;  // ADDI R3, R0, 25
        mips.Mem[3] = 32'h0ce77800;  // OR dummy
        mips.Mem[4] = 32'h0ce77800;  // OR dummy
        mips.Mem[5] = 32'h00222000;  // ADD R4, R1, R2
        mips.Mem[6] = 32'h0ce77800;  // OR dummy
        mips.Mem[7] = 32'h00832800;  // ADD R5, R4, R3
        mips.Mem[8] = 32'hfc000000;  // HLT

        // CPU state
        mips.PC = 0;
        mips.HALTED = 0;
        mips.TAKEN_BRANCH = 0;

        mips.IF_ID_IR  = 0;
        mips.ID_EX_IR  = 0;
        mips.EX_MEM_IR = 0;
        mips.MEM_WB_IR = 0;
    end

    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, test1_mips32);

        #600;   

        $display("FINAL REGISTER VALUES");
        for (k = 0; k < 6; k = k + 1)
            $display("R%0d = %0d", k, mips.Reg[k]);

        $finish;
    end

endmodule

