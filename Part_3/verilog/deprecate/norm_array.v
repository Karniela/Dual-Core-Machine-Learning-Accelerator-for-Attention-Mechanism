module norm_array(clk, reset, data_in, data_out, rd, wr);

parameter pr = 8;
parameter bw = 4;
parameter psum_bw = 2*bw + 4;
parameter col = 8;

input clk, reset, rd, wr;
input [psum_bw-1:0] data_in;
output [2*psum_bw-1:0] data_out;

reg [3:0] counter, counter_nxt;
reg [2:0] idx, idx_nxt;

wire [col*psum_bw-1:0] norm_in;
wire [col*2*psum_bw-1:0] norm_out;
reg [col-1:0] norm_div;
reg [col-1:0] norm_wr;
reg [col-1:0] norm_full;
reg [col-1:0] norm_ready;

assign data_out = (rd) ? norm_out[(idx+1)*2*psum_bw-1:idx*2*psum_bw] : data_out;
assign norm_in[(idx+1)*psum_bw-1:idx*psum_bw] = data_in;
genvar i;

for(i=0; i<col; i=i+1) begin: norm_idx
    norm #(.bw(psum_bw)) 
        norm_instance(.clk(clk), .in(norm_in[(i+1)*psum_bw-1:i*psum_bw]), 
                      .out(norm_out[(i+1)*2*psum_bw-1:i*2*psum_bw]), .div(norm_div[i]), 
                      .wr(norm_wr[i]), .o_full(norm_full[i]), .reset(reset), .o_ready(norm_ready[i]));
end

always @(*) begin
  if(rd || wr) begin
    counter_nxt = (counter == pr-1) ? 0 : counter+1;
    idx_nxt = (counter != pr-1) ? idx: (idx == col-1) ? 0 : idx+1;
  end
  if(rd) norm_div[idx] = 1;
  if(wr) norm_wr[idx] = 1;
end

always @(posedge clk or posedge reset) begin
  if(reset) begin
    counter <= 4'b0000;
    idx     <= 3'b000;
  end
  else begin
    counter <= counter_nxt;
    idx     <= idx_nxt;
  end
end


endmodule