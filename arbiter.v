module weighted_rr_arbiter(
    input  clk,
    input  rst,

    input  req0,
    input  req1,
    input  req2,
    input  req3,

    output reg master0,
    output reg master1,
    output reg master2,
    output reg master3
);

reg [1:0] state;
reg [2:0] count;

//--------------------------------------------------
// Sequential Logic
//--------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= 2'd0;
        count <= 3'd0;
    end
    else
    begin
        case(state)

        //--------------------------------------------------
        // MASTER 0 (Weight = 4)
        //--------------------------------------------------
        2'd0:
        begin
            if(!req0)
            begin
                state <= 2'd0;
                count <= 3'd0;
            end
            else if(count < 3)
            begin
                count <= count + 1;
            end
            else
            begin
                count <= 3'd0;

                // Next master must be M1.
                // If M1 request is LOW, restart from M0.
                if(req1)
                    state <= 2'd1;
                else
                    state <= 2'd0;
            end
        end

        //--------------------------------------------------
        // MASTER 1 (Weight = 1)
        //--------------------------------------------------
        2'd1:
        begin
            count <= 3'd0;

            // Next master must be M2.
            // If M2 request is LOW, restart from M0.
            if(req2)
                state <= 2'd2;
            else
                state <= 2'd0;
        end

        //--------------------------------------------------
        // MASTER 2 (Weight = 1)
        //--------------------------------------------------
        2'd2:
        begin
            count <= 3'd0;

            // Next master must be M3.
            // If M3 request is LOW, restart from M0.
            if(req3)
                state <= 2'd3;
            else
                state <= 2'd0;
        end

        //--------------------------------------------------
        // MASTER 3 (Weight = 1)
        //--------------------------------------------------
        2'd3:
        begin
            count <= 3'd0;

            // After M3 always return to M0.
            state <= 2'd0;
        end

        default:
        begin
            state <= 2'd0;
            count <= 3'd0;
        end

        endcase
    end
end

//--------------------------------------------------
// Combinational Grant Logic
//--------------------------------------------------
always @(*)
begin
    master0 = 1'b0;
    master1 = 1'b0;
    master2 = 1'b0;
    master3 = 1'b0;

    case(state)

        2'd0:
        begin
            if(req0)
                master0 = 1'b1;
        end

        2'd1:
        begin
            if(req1)
                master1 = 1'b1;
        end

        2'd2:
        begin
            if(req2)
                master2 = 1'b1;
        end

        2'd3:
        begin
            if(req3)
                master3 = 1'b1;
        end

    endcase
end

endmodule