// Simulate using:
// https://hdlbits.01xz.net/wiki/Iverilog

module top_module ();
    reg clk=0;
    always #5 clk = ~clk;
    initial `probe_start;
    `probe(clk);

    // 1. Declare 4-bit regs for inputs and a 4-bit wire for the sum
    reg [3:0] a=0, b=0;
    reg cin=0;
    wire [3:0] sum;
    wire cout;

    initial begin
        // Test 1: Simple addition (2 + 3 = 5)
        #10 a <= 4'd2; b <= 4'd3; cin <= 0;
        
        // Test 2: Addition with a carry-in (5 + 5 + 1 = 11)
        #20 a <= 4'd5; b <= 4'd5; cin <= 1;
        
        // Test 3: Maximum value / Overflow (15 + 1 = 0, cout=1)
        #20 a <= 4'hf; b <= 4'h1; cin <= 0;
        
        #50 $finish;
    end

    // 2. Instantiate your 4-bit adder
    adder4 my_adder (
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum), 
        .cout(cout)
    );
    
    // Add these to your top_module
    `probe(a);
    `probe(b);
    `probe(cin);
    `probe(sum);
    `probe(cout);

endmodule

module adder4(input [3:0] a, input [3:0] b, input cin, output [3:0] sum, output cout);
    wire cout1, cout2, cout3;
    
    fullAdder adder1(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout1));
    fullAdder adder2(.a(a[1]), .b(b[1]), .cin(cout1), .sum(sum[1]), .cout(cout2));
    fullAdder adder3(.a(a[2]), .b(b[2]), .cin(cout2), .sum(sum[2]), .cout(cout3));
    fullAdder adder4(.a(a[3]), .b(b[3]), .cin(cout3), .sum(sum[3]), .cout(cout));
    
endmodule

module fullAdder(input a, input b, input cin, output sum, output cout);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule
