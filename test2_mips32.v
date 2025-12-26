`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 04:13:17 PM
// Design Name: 
// Module Name: test2_mips32
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


module test2_mips32;
    // Load from memory, add immediate, store back

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

        mips.Mem[0] = 32'h28010078;  // ADDI R1, R0, 120
        mips.Mem[1] = 32'h0c631800;  // OR   R3, R3, R3 (NOP)
        mips.Mem[2] = 32'h20220000;  // LW   R2, 0(R1)
        mips.Mem[3] = 32'h0c631800;  // OR   R3, R3, R3 (NOP)
        mips.Mem[4] = 32'h2842002d;  // ADDI R2, R2, 45
        mips.Mem[5] = 32'h0c631800;  // OR   R3, R3, R3 (NOP)
        mips.Mem[6] = 32'h24220001;  // SW   R2, 1(R1)
        mips.Mem[7] = 32'hfc000000;  // HLT

        // Data memory
        mips.Mem[120] = 85;

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
        $dumpfile("mips_test2.vcd");
        $dumpvars(0, test2_mips32);

        #600;

        $display("MEMORY RESULT");
        $display("Mem[120] = %0d", mips.Mem[120]);
        $display("Mem[121] = %0d", mips.Mem[121]);

        $finish;
    end

endmodule

