module multiplier
  #(
   // This is here to help, but we won't change it.
   parameter width_p = 16)
  (input [0:0] clk_i
  ,input [0:0] reset_i
  ,input [0:0] ready_i
  ,input [0:0] valid_i
  ,input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,output [0:0] ready_o
  ,output [0:0] valid_o 
  ,output [(2 * width_p) - 1:0] c_o 
  );
  
  logic [width_p-1:0] a_l;
  logic [width_p-1:0] b_l;
  
  wire [(2*width_p)-1:0] c_out;
  
  logic [(2*width_p)-1:0] c_l;
 
  logic valid_l;
  
  assign ready_o = ~valid_l | ready_i;
  
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      valid_l <= 1'b0;
    end 
    else if (ready_o) begin
      valid_l <= valid_i;
      if (valid_i) begin
        a_l <= a_i;
        b_l <= b_i;
      end
    end
  end

  wire [47:0] p_out;
  always_ff @(posedge clk_i) begin
    if (reset_i)
      c_l <= '0;
    else if (ready_o && valid_i)
      c_l <= p_out[(2*width_p)-1:0];
  end

  assign valid_o = valid_l;
  assign c_o = c_l;

  DSP48E1 #(
    .ACASCREG(32'sd0),
    .ADREG(32'sd0),
    .ALUMODEREG(32'sd0),
    .AREG(32'sd0),
    .A_INPUT("DIRECT"),
    .BCASCREG(32'sd0),
    .BREG(32'sd0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(32'sd0),
    .CARRYINSELREG(32'sd0),
    .CREG(32'sd0),
    .DREG(32'sd0),
    .INMODEREG(32'sd0),
    .MREG(32'sd0),
    .OPMODEREG(32'sd0),
    .PREG(32'sd0),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_SIMD("ONE48")
  ) _79_ (
    .A({ 14'h0000, a_i }),
    .ACIN(30'h00000000),
    .ALUMODE(4'h0),
    .B({ 2'h0, b_i }),
    .BCIN(18'h00000),
    .C(48'h000000000000),
    .CARRYIN(1'h0),
    .CARRYINSEL(3'h0),
    .D(25'h0000000),
    .INMODE(5'h00),
    .OPMODE(7'h05),
    .P(p_out),
    .PCIN(48'h000000000000)
  );

endmodule
