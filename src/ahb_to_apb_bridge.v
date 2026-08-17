module ahb_to_apb_bridge (
    input         HCLK,
    input         HRESETn,

    // AHB Slave Interface
    input  [31:0] HADDR,
    input  [31:0] HWDATA,
    input         HWRITE,
    input  [1:0]  HTRANS,
    input         HSEL,
    output reg [31:0] HRDATA,
    output reg        HREADYOUT,
    output reg        HRESP,

    // APB Interface
    output reg [31:0] PADDR,
    output reg [31:0] PWDATA,
    output reg        PWRITE,
    output reg        PSEL,
    output reg        PENABLE,
    output reg        PREADY,
    output reg [31:0] PRDATA
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam SETUP  = 2'b01;
    localparam ACCESS = 2'b10;

    reg [1:0] state;

    // Latched AHB transaction
    reg [31:0] addr_reg;
    reg [31:0] data_reg;
    reg        write_reg;

    // APB peripheral memory model
    reg [31:0] peripheral_mem [0:255];

    integer i;

    // Detect valid AHB transfer
    wire ahb_transfer_valid;

    assign ahb_transfer_valid =
            HSEL &&
            (HTRANS == 2'b10 || HTRANS == 2'b11);

    // FSM and transaction registers
    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn) begin

            state      <= IDLE;

            addr_reg   <= 32'b0;
            data_reg   <= 32'b0;
            write_reg  <= 1'b0;

            HRDATA     <= 32'b0;
            HREADYOUT  <= 1'b1;
            HRESP      <= 1'b0;

        end

        else begin

            case (state)

                IDLE: begin

                    HREADYOUT <= 1'b1;
                    HRESP     <= 1'b0;

                    if (ahb_transfer_valid) begin

                        addr_reg  <= HADDR;
                        data_reg  <= HWDATA;
                        write_reg <= HWRITE;

                        HREADYOUT <= 1'b0;

                        state <= SETUP;
                    end
                end


                SETUP: begin

                    HREADYOUT <= 1'b0;

                    state <= ACCESS;
                end


                ACCESS: begin

                    HREADYOUT <= 1'b1;
                    HRESP     <= 1'b0;

                    if (write_reg) begin

                        peripheral_mem[addr_reg[9:2]]
                            <= data_reg;

                    end

                    else begin

                        HRDATA <= peripheral_mem[addr_reg[9:2]];

                    end

                    state <= IDLE;
                end


                default: begin

                    state <= IDLE;
                    HREADYOUT <= 1'b1;
                    HRESP <= 1'b0;

                end

            endcase
        end
    end


    // APB signal generation
    always @(*) begin

        // Default values
        PADDR   = addr_reg;
        PWDATA  = data_reg;
        PWRITE  = write_reg;

        PSEL    = 1'b0;
        PENABLE = 1'b0;
        PREADY  = 1'b0;
        PRDATA  = 32'b0;

        case (state)

            SETUP: begin

                PSEL    = 1'b1;
                PENABLE = 1'b0;
                PREADY  = 1'b0;

            end


            ACCESS: begin

                PSEL    = 1'b1;
                PENABLE = 1'b1;
                PREADY  = 1'b1;

                if (!write_reg)
                    PRDATA = peripheral_mem[addr_reg[9:2]];

            end


            default: begin

                PSEL    = 1'b0;
                PENABLE = 1'b0;
                PREADY  = 1'b0;

            end

        endcase
    end


    // Initialize peripheral memory
    initial begin

        for (i = 0; i < 256; i = i + 1)
            peripheral_mem[i] = 32'b0;

    end

endmodule
