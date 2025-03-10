module pc (
    input logic clk,
    input logic rst,           // Active high! very smart, very smart
    input logic pc_wen,      // write enable
    input logic [31:0] pc_din, // Next PC value
    output logic [31:0] pc_dout // Current PC value
);

    // Register for storing the program counter value
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset PC to the default starting address
            pc_dout <= 32'h00000000;
        end
        else if (pc_wen) begin
            // Update PC with the new value when pc_write is asserted
            pc_dout <= pc_din;
        end
    end

endmodule
