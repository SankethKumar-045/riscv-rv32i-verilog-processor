`timescale 1ns/1ps

module tb_riscv_core;

    reg clk;
    reg reset;

    // Instantiate processor
    riscv_core dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

    $dumpfile("waveforms/riscv_core.vcd");
    $dumpvars(0, tb_riscv_core);

        clk   = 1'b0;
        reset = 1'b1;

        // Reset processor
        #12;
        reset = 1'b0;

        // -------------------------------------------------
        // Program
        // -------------------------------------------------


// ADDI x1, x0, 10
dut.imem.memory[0] = 32'h00A00093;

// JAL x2, +8
// x2 should receive PC + 4 = 4
// Jump to instruction at PC + 8
dut.imem.memory[1] = 32'h0080016F;

// ADDI x3, x0, 99
// This instruction should be skipped
dut.imem.memory[2] = 32'h06300193;

// ADDI x4, x0, 55
// This instruction should execute
dut.imem.memory[3] = 32'h03700213;

        // Wait for execution
        #80;

        // Display register results
        $display("======================================");
        $display("RISC-V PROCESSOR TEST RESULTS");
        $display("======================================");

        $display("x1 = %0d", dut.regs.registers[1]);
        $display("x2 = %0d", dut.regs.registers[2]);
        $display("x3 = %0d", dut.regs.registers[3]);
        $display("x4 = %0d", dut.regs.registers[4]);
        $display("x5 = %0d", dut.regs.registers[5]);
        $display("x6 = %0d", dut.regs.registers[6]);
        $display("x7 = %0d", dut.regs.registers[7]);

        $display("======================================");

        $finish;

    end

endmodule