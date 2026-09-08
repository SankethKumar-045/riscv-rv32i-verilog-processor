module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,

    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg        alu_src,
    output reg        mem_to_reg,
    output reg        branch,
    output reg        jump,
    output reg [1:0]  branch_type,
    output reg [1:0]  alu_op
);

    always @(*) begin

        // Default control signals
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        alu_src     = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        branch_type = 2'b00;
        alu_op      = 2'b00;

        case (opcode)

            // R-type: ADD, SUB, AND, OR, XOR
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 2'b10;
            end

            // I-type: ADDI
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b11;
            end

            // LW
            7'b0000011: begin
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 2'b00;
            end

            // SW
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end

            // Branch instructions
            7'b1100011: begin

                branch  = 1'b1;
                alu_src = 1'b0;
                alu_op  = 2'b01;

                case (funct3)

                    // BEQ
                    3'b000:
                        branch_type = 2'b01;

                    // BNE
                    3'b001:
                        branch_type = 2'b10;

                    default: begin
                        branch      = 1'b0;
                        branch_type = 2'b00;
                    end

                endcase
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
            end

            default: begin
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                alu_src     = 1'b0;
                mem_to_reg  = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
                branch_type = 2'b00;
                alu_op      = 2'b00;
            end

        endcase

    end

endmodule