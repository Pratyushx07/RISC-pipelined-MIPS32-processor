`timescale 1ns / 1ps

module test3_mips32;
    // Factorial of N stored at Mem[200], result stored at Mem[198]

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

        // Program
        mips.Mem[0]  = 32'h280a00c8;  // ADDI  R10, R0, 200
        mips.Mem[1]  = 32'h28020001;  // ADDI  R2,  R0, 1
        mips.Mem[2]  = 32'h0e94a000;  // OR    R20, R20, R20 (NOP)
        mips.Mem[3]  = 32'h21430000;  // LW    R3, 0(R10)
        mips.Mem[4]  = 32'h0e94a000;  // OR    R20, R20, R20 (NOP)
        mips.Mem[5]  = 32'h14431000;  // MUL   R2, R2, R3   (LOOP)
        mips.Mem[6]  = 32'h2c630001;  // SUBI  R3, R3, 1
        mips.Mem[7]  = 32'h0e94a000;  // OR    R20, R20, R20 (NOP)
        mips.Mem[8]  = 32'h3460fffc;  // BNEQZ R3, LOOP (-4)
        mips.Mem[9]  = 32'h2542fffe;  // SW    R2, -2(R10)
        mips.Mem[10] = 32'hfc000000;  // HLT

        // Data
        mips.Mem[200] = 7;            // factorial input

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
        $dumpfile("mips_test3.vcd");
        $dumpvars(0, test3_mips32);
    end

    always @(posedge clk1)
    begin
        if (mips.HALTED) begin
            $display("FACTORIAL RESULT");
            $display("Mem[200] = %0d", mips.Mem[200]);
            $display("Mem[198] = %0d", mips.Mem[198]);
            $finish;
        end
    end

endmodule

