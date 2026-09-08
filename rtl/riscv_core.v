module riscv_core (
    input wire clk,
    input wire reset
);

    // =========================================================
    // Program Counter
    // =========================================================
    wire [31:0] pc;
    reg  [31:0] next_pc;

    // =========================================================
    // Instruction Memory
    // =========================================================
    wire [31:0] instruction;

    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

    // =========================================================
    // Instruction Fields
    // =========================================================
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [4:0] rd     = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    // =========================================================
    // Control Unit
    // =========================================================
    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire       alu_src;
    wire       mem_to_reg;
    wire       branch;
    wire       jump;
    wire [1:0] branch_type;
    wire [1:0] alu_op;

    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .branch_type(branch_type),
        .alu_op(alu_op)
    );

    // =========================================================
    // Register File
    // =========================================================
    wire [31:0] register_data1;
    wire [31:0] register_data2;

    reg [31:0] write_back_data;

    register_file regs (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(register_data1),
        .read_data2(register_data2)
    );

    // =========================================================
    // Immediate Generator
    // =========================================================
    wire [31:0] immediate;

    immediate_generator imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );

    // =========================================================
    // ALU Control
    // =========================================================
    reg [3:0] alu_control;

    always @(*) begin
        case (alu_op)

            // Load / Store / Address calculation
            2'b00:
                alu_control = 4'b0000;

            // Branch comparison
            2'b01:
                alu_control = 4'b0001;

            // R-type instructions
            2'b10: begin
                case ({funct7, funct3})

                    10'b0000000_000: alu_control = 4'b0000; // ADD
                    10'b0100000_000: alu_control = 4'b0001; // SUB
                    10'b0000000_111: alu_control = 4'b0010; // AND
                    10'b0000000_110: alu_control = 4'b0011; // OR
                    10'b0000000_100: alu_control = 4'b0100; // XOR
                    10'b0000000_010: alu_control = 4'b0101; // SLT

                    default: alu_control = 4'b0000;

                endcase
            end

            // I-type instructions
            2'b11: begin
                case (funct3)

                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b010: alu_control = 4'b0101; // SLTI

                    default: alu_control = 4'b0000;

                endcase
            end

            default:
                alu_control = 4'b0000;

        endcase
    end

    // =========================================================
    // ALU Input Selection
    // =========================================================
    wire [31:0] alu_input_b;

    assign alu_input_b =
        alu_src ? immediate : register_data2;

    wire [31:0] alu_result;
    wire        alu_zero;

    alu alu_unit (
        .a(register_data1),
        .b(alu_input_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(alu_zero)
    );

    // =========================================================
    // Data Memory
    // =========================================================
    wire [31:0] memory_read_data;

    data_memory dmem (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(register_data2),
        .read_data(memory_read_data)
    );

    // =========================================================
    // Writeback
    // =========================================================
    always @(*) begin
        if (mem_to_reg)
            write_back_data = memory_read_data;
        else if (jump)
            write_back_data = pc + 32'd4;
        else
            write_back_data = alu_result;
    end

    // =========================================================
    // Branch Decision
    // =========================================================
    reg branch_taken;

    always @(*) begin
        branch_taken = 1'b0;

        if (branch) begin
            case (branch_type)

                // BEQ
                2'b01:
                    branch_taken = (register_data1 == register_data2);

                // BNE
                2'b10:
                    branch_taken = (register_data1 != register_data2);

                default:
                    branch_taken = 1'b0;

            endcase
        end
    end

    // =========================================================
    // Next PC Logic
    // =========================================================
    always @(*) begin

        // Default: next instruction
        next_pc = pc + 32'd4;

        // Branch
        if (branch_taken)
            next_pc = pc + immediate;

        // JAL
        if (jump)
            next_pc = pc + immediate;

    end

    // =========================================================
    // Program Counter Register
    // =========================================================
    pc pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

endmodule