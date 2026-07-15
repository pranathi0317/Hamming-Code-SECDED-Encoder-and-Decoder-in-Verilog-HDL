module hamming84_decoder(
    input  [7:0] codeword,              // [7] = overall parity bit
    output reg [3:0] data,
    output reg [2:0] error_pos,
    output reg single_error,
    output reg double_error,
    output reg error_detected,
    output reg [7:0] corrected_codeword
);

    reg s1, s2, s4;
    reg overall_parity;

    always @(*) begin

        // Syndrome calculation using bits [6:0]
        s1 = codeword[0] ^ codeword[2] ^ codeword[4] ^ codeword[6];
        s2 = codeword[1] ^ codeword[2] ^ codeword[5] ^ codeword[6];
        s4 = codeword[3] ^ codeword[4] ^ codeword[5] ^ codeword[6];

        error_pos = {s4, s2, s1};

        // Overall parity check including parity bit codeword[7]
        overall_parity = codeword[0] ^ codeword[1] ^ codeword[2] ^
                         codeword[3] ^ codeword[4] ^ codeword[5] ^
                         codeword[6] ^ codeword[7];

        corrected_codeword = codeword;

        single_error = 1'b0;
        double_error = 1'b0;
        error_detected = 1'b0;

        if(error_pos == 3'b000 && overall_parity == 1'b0) begin
            // No error
            error_detected = 1'b0;
        end

        else if(error_pos != 3'b000 && overall_parity == 1'b1) begin
            // Single-bit error in bits [6:0]
            error_detected = 1'b1;
            single_error = 1'b1;

            case(error_pos)
                3'b001: corrected_codeword[0] = ~codeword[0];
                3'b010: corrected_codeword[1] = ~codeword[1];
                3'b011: corrected_codeword[2] = ~codeword[2];
                3'b100: corrected_codeword[3] = ~codeword[3];
                3'b101: corrected_codeword[4] = ~codeword[4];
                3'b110: corrected_codeword[5] = ~codeword[5];
                3'b111: corrected_codeword[6] = ~codeword[6];
            endcase
        end

        else if(error_pos == 3'b000 && overall_parity == 1'b1) begin
            // Error only in overall parity bit
            error_detected = 1'b1;
            single_error = 1'b1;
            corrected_codeword[7] = ~codeword[7];
        end

        else if(error_pos != 3'b000 && overall_parity == 1'b0) begin
            // Double-bit error detected, do not correct
            error_detected = 1'b1;
            double_error = 1'b1;
            corrected_codeword = codeword;
        end

        // Extract corrected data bits
        data[0] = corrected_codeword[2];
        data[1] = corrected_codeword[4];
        data[2] = corrected_codeword[5];
        data[3] = corrected_codeword[6];

    end

endmodule