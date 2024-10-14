// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk, mem_in, inst, reset, out);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 16;

input  clk; 
input  [pr*bw-1:0] mem_in; 
input  [19:0] inst; 
input  reset;
output [bw_psum*col-1:0] out;

wire [bw_psum*col-1:0] sfp_out;
wire [bw_psum*col-1:0] core_out;
reg pmem_rd_buffer;

assign out = (inst[19]) ? core_out : sfp_out;
core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in), 
      .inst(inst[18:0]),
      .out(core_out)
);

// sfp_row #(.col(col), .bw(bw), .bw_psum(bw_psum)) sfp_instance(
//       .clk(clk), .acc(pmem_rd_buffer && !inst[19]), .div(inst[19]), .sum_in(1'b0), .sfp_in(core_out), .sfp_out(out), .reset(reset));

sfp #(.col(col), .bw(bw), .bw_psum(bw_psum)) sfp_instance(
      .clk(clk), .norm(pmem_rd_buffer), .sum_in(24'b0000_0000_0000_0000_0000_0000), .sfp_in(core_out), .sfp_out(sfp_out), .reset(reset));

always @(posedge clk or posedge reset) begin
      if(reset) pmem_rd_buffer <= 0;
      else pmem_rd_buffer <= inst[1];
end

endmodule
