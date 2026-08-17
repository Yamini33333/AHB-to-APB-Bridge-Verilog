`timescale 1ns/1ps

module ahb_apb_tb;

    reg         HCLK;
    reg         HRESETn;

    reg  [31:0] HADDR;
    reg  [31:0] HWDATA;
    reg         HWRITE;
    reg  [1:0]  HTRANS;
    reg         HSEL;

    wire [31:0] HRDATA;
    wire        HREADYOUT;
    wire        HRESP;

    wire [31:0] PADDR;
    wire [31:0] PWDATA;
    wire        PWRITE;
    wire        PSEL;
    wire        PENABLE;
    wire        PREADY;
    wire [31:0] PRDATA;


    // Instantiate the AHB-to-APB bridge
    ahb_to_apb_bridge dut (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSEL(HSEL),

        .HRDATA(HRDATA),
        .HREADYOUT(HREADYOUT),
        .HRESP(HRESP),

        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PREADY(PREADY),
        .PRDATA(PRDATA)
    );


    // Clock generation
    always #5 HCLK = ~HCLK;


    // Test sequence
    initial begin

        HCLK   = 1'b0;
        HRESETn = 1'b0;

        HADDR  = 32'b0;
        HWDATA = 32'b0;
        HWRITE = 1'b0;
        HTRANS = 2'b00;
        HSEL   = 1'b0;

        // Reset
        #20;
        HRESETn = 1'b1;

        // -------------------------
        // AHB WRITE
        // -------------------------

        #10;

        HSEL   = 1'b1;
        HWRITE = 1'b1;
        HTRANS = 2'b10;
        HADDR  = 32'h00000010;
        HWDATA = 32'h12345678;

        #30;

        HSEL   = 1'b0;
        HWRITE = 1'b0;
        HTRANS = 2'b00;

        // -------------------------
        // AHB READ
        // -------------------------

        #20;

        HSEL   = 1'b1;
        HWRITE = 1'b0;
        HTRANS = 2'b10;
        HADDR  = 32'h00000010;

        #30;

        HSEL   = 1'b0;
        HTRANS = 2'b00;

        #20;

        $display("Read Data = %h", HRDATA);

        $finish;

    end


    // Monitor important signals
    initial begin

        $monitor(
            "Time=%0t | HADDR=%h | HWRITE=%b | HWDATA=%h | HRDATA=%h | PSEL=%b | PENABLE=%b",
            $time,
            HADDR,
            HWRITE,
            HWDATA,
            HRDATA,
            PSEL,
            PENABLE
        );

    end

endmodule
