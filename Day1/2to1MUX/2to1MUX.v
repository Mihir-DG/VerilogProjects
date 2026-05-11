// Verify with Timing Diagram via:
// https://hdlbits.01xz.net/wiki/Iverilog

module top_module ();
    // 1. Clock and Simulation Setup (Keep as is)
    reg clk=0;
    always #5 clk = ~clk;
    initial `probe_start;
    `probe(clk);

    // 2. Declare regs for your MUX inputs
    reg a=0, b=0, sel=0;
    wire out_wire;

    // 3. Drive the signals over time
    initial begin
        #10 a <= 1;        // Set input A high
        #10 b <= 0;        // Set input B low
        #10 sel <= 1;      // Switch MUX to pick B
        #20 sel <= 0;      // Switch MUX to pick A
        #50 $finish;
    end

    // 4. Connect your MUX module
    mux2to1 my_mux (
        .a(a), 
        .b(b), 
        .sel(sel), 
        .out(out_wire) // You'll need a 'wire out_wire;' declared above
    );

endmodule

// 5. Your MUX definition goes here
module mux2to1 (input a, input b, input sel, output reg out);
	
    always @(*) begin
        case(sel)
            1'b0: out = a;
            1'b1: out = b;
        endcase
    end
    
    `probe(a);
    `probe(b);
    `probe(sel);
    `probe(out);
endmodule
