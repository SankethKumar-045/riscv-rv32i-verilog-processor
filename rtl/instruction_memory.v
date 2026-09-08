module instruction_memory (
    input  wire [31:0] address,
    output reg  [31:0] instruction
);

    reg [31:0] memory [0:255];

    always @(*) begin
        instruction = memory[address[9:2]];
    end

endmodule