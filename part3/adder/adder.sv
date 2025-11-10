module adder
  #(
   parameter width_p = 32)
  (input [0:0] clk_i
  ,input [0:0] reset_i
  ,input [0:0] ready_i
  ,input [0:0] valid_i
  ,input [width_p-1:0] a_i
  ,input [width_p-1:0] b_i
  ,output [0:0] ready_o
  ,output [0:0] valid_o 
  ,output [width_p:0] c_o 
  );
  
  logic [width_p-1:0] a_l;
  logic [width_p-1:0] b_l;
    
  logic [width_p:0] c_l;
  wire [width_p:0] c_out;
 
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
      c_l <= p_out[width_p:0];
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
    .USE_MULT("NONE"),
    .USE_SIMD("ONE48")
  ) _79_ (
    .A({16'h0000, a_i[width_p-1:18]}),
    .ACIN(30'h00000000),
    .ALUMODE(4'h0),
    .B({a_i[17:0]}),
    .BCIN(18'h00000),
    .C({16'h0000,b_i[width_p-1:0]}),
    .CARRYIN(1'h0),
    .CARRYINSEL(3'h0),
    .D(25'h0000000),
    .INMODE(5'h00),
    .OPMODE(7'b0110011),
    .P(p_out),
    .PCIN(48'h000000000000)
  );

endmodule
