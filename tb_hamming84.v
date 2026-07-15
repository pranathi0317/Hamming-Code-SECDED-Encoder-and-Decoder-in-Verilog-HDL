`timescale 1ns/1ps

module tb_hamming84;

    reg [7:0] codeword;

    wire [3:0] data;
    wire [2:0] error_pos;
    wire single_error;
    wire double_error;
    wire error_detected;
    wire [7:0] corrected_codeword;

    hamming84_decoder DUT(
        .codeword(codeword),
        .data(data),
        .error_pos(error_pos),
        .single_error(single_error),
        .double_error(double_error),
        .error_detected(error_detected),
        .corrected_codeword(corrected_codeword)
    );

    initial begin

        $display("Time\tCodeword\tErr\tSingle\tDouble\tPos\tCorrected\tData");

        // Original 7-bit Hamming code = 0110011
        // Overall parity bit = 0 because 0110011 has even number of 1s
        // Extended codeword = 00110011

        // No error
        codeword = 8'b00110011;
        #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, codeword, error_detected, single_error,
                 double_error, error_pos, corrected_codeword, data);

        // Single-bit error in bit 0
        codeword = 8'b00110010;
        #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, codeword, error_detected, single_error,
                 double_error, error_pos, corrected_codeword, data);

        // Single-bit error in overall parity bit
        codeword = 8'b10110011;
        #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, codeword, error_detected, single_error,
                 double_error, error_pos, corrected_codeword, data);

        // Double-bit error: detected but not corrected
        codeword = 8'b00110000;
        #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, codeword, error_detected, single_error,
                 double_error, error_pos, corrected_codeword, data);

        $finish;

    end

endmodule