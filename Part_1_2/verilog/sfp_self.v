// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp (clk, norm, fifo_ext_rd, sum_in, sum_out, sfp_in, sfp_out, reset);

  parameter col = 8;
  parameter bw = 8;
  parameter bw_psum = 2*bw+4;

  input  clk, norm, fifo_ext_rd, reset;
  input  [bw_psum+3:0] sum_in;
  input  [col*bw_psum-1:0] sfp_in;
  wire  [col*bw_psum-1:0] abs;
  output [col*bw_psum-1:0] sfp_out;
  output [bw_psum+3:0] sum_out;
  wire [bw_psum+3:0] sum_this_core;
  wire [bw_psum+3:0] sum_2core;

  wire signed [bw_psum-1:0] sfp_in_sign0;
  wire signed [bw_psum-1:0] sfp_in_sign1;
  wire signed [bw_psum-1:0] sfp_in_sign2;
  wire signed [bw_psum-1:0] sfp_in_sign3;
  wire signed [bw_psum-1:0] sfp_in_sign4;
  wire signed [bw_psum-1:0] sfp_in_sign5;
  wire signed [bw_psum-1:0] sfp_in_sign6;
  wire signed [bw_psum-1:0] sfp_in_sign7;


  // reg [bw_psum+3:0] sfp_out_0;
  // reg [bw_psum+3:0] sfp_out_1;
  // reg [bw_psum+3:0] sfp_out_2;
  // reg [bw_psum+3:0] sfp_out_3;
  // reg [bw_psum+3:0] sfp_out_4;
  // reg [bw_psum+3:0] sfp_out_5;
  // reg [bw_psum+3:0] sfp_out_6;
  // reg [bw_psum+3:0] sfp_out_7;
  wire [bw_psum+3:0] sum;
  reg fifo_wr;

  assign sfp_in_sign0 =  sfp_in[bw_psum*1-1 : bw_psum*0];
  assign sfp_in_sign1 =  sfp_in[bw_psum*2-1 : bw_psum*1];
  assign sfp_in_sign2 =  sfp_in[bw_psum*3-1 : bw_psum*2];
  assign sfp_in_sign3 =  sfp_in[bw_psum*4-1 : bw_psum*3];
  assign sfp_in_sign4 =  sfp_in[bw_psum*5-1 : bw_psum*4];
  assign sfp_in_sign5 =  sfp_in[bw_psum*6-1 : bw_psum*5];
  assign sfp_in_sign6 =  sfp_in[bw_psum*7-1 : bw_psum*6];
  assign sfp_in_sign7 =  sfp_in[bw_psum*8-1 : bw_psum*7];


  assign sfp_out[bw_psum*1-1 : bw_psum*0] = (abs[bw_psum*1-1 : bw_psum*0] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*2-1 : bw_psum*1] = (abs[bw_psum*2-1 : bw_psum*1] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*3-1 : bw_psum*2] = (abs[bw_psum*3-1 : bw_psum*2] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*4-1 : bw_psum*3] = (abs[bw_psum*4-1 : bw_psum*3] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*5-1 : bw_psum*4] = (abs[bw_psum*5-1 : bw_psum*4] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*6-1 : bw_psum*5] = (abs[bw_psum*6-1 : bw_psum*5] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*7-1 : bw_psum*6] = (abs[bw_psum*7-1 : bw_psum*6] << 4'b1000) / sum_2core;
  assign sfp_out[bw_psum*8-1 : bw_psum*7] = (abs[bw_psum*8-1 : bw_psum*7] << 4'b1000) / sum_2core;

  assign sum =  {4'b0, abs[bw_psum*1-1 : bw_psum*0]} +
                {4'b0, abs[bw_psum*2-1 : bw_psum*1]} +
                {4'b0, abs[bw_psum*3-1 : bw_psum*2]} +
                {4'b0, abs[bw_psum*4-1 : bw_psum*3]} +
                {4'b0, abs[bw_psum*5-1 : bw_psum*4]} +
                {4'b0, abs[bw_psum*6-1 : bw_psum*5]} +
                {4'b0, abs[bw_psum*7-1 : bw_psum*6]} +
                {4'b0, abs[bw_psum*8-1 : bw_psum*7]} ;
  assign sum_2core = sum + sum_in;

  assign abs[bw_psum*1-1 : bw_psum*0] = (sfp_in[bw_psum*1-1]) ?  (~sfp_in[bw_psum*1-1 : bw_psum*0] + 1)  :  sfp_in[bw_psum*1-1 : bw_psum*0];
  assign abs[bw_psum*2-1 : bw_psum*1] = (sfp_in[bw_psum*2-1]) ?  (~sfp_in[bw_psum*2-1 : bw_psum*1] + 1)  :  sfp_in[bw_psum*2-1 : bw_psum*1];
  assign abs[bw_psum*3-1 : bw_psum*2] = (sfp_in[bw_psum*3-1]) ?  (~sfp_in[bw_psum*3-1 : bw_psum*2] + 1)  :  sfp_in[bw_psum*3-1 : bw_psum*2];
  assign abs[bw_psum*4-1 : bw_psum*3] = (sfp_in[bw_psum*4-1]) ?  (~sfp_in[bw_psum*4-1 : bw_psum*3] + 1)  :  sfp_in[bw_psum*4-1 : bw_psum*3];
  assign abs[bw_psum*5-1 : bw_psum*4] = (sfp_in[bw_psum*5-1]) ?  (~sfp_in[bw_psum*5-1 : bw_psum*4] + 1)  :  sfp_in[bw_psum*5-1 : bw_psum*4];
  assign abs[bw_psum*6-1 : bw_psum*5] = (sfp_in[bw_psum*6-1]) ?  (~sfp_in[bw_psum*6-1 : bw_psum*5] + 1)  :  sfp_in[bw_psum*6-1 : bw_psum*5];
  assign abs[bw_psum*7-1 : bw_psum*6] = (sfp_in[bw_psum*7-1]) ?  (~sfp_in[bw_psum*7-1 : bw_psum*6] + 1)  :  sfp_in[bw_psum*7-1 : bw_psum*6];
  assign abs[bw_psum*8-1 : bw_psum*7] = (sfp_in[bw_psum*8-1]) ?  (~sfp_in[bw_psum*8-1 : bw_psum*7] + 1)  :  sfp_in[bw_psum*8-1 : bw_psum*7];

  wire  full;
  wire  empty; 


  // fifo #(.DEPTH(6'd32)) fifo_inst_int (
  //   .r_clk(clk), 
  //   .w_clk(clk), 
  //   .i_data(sum_q),
  //   .o_data(sum_this_core), 
  //   .i_read(fifo_ext_rd), 
  //   .i_write(fifo_wr), 
  //   .rst(reset),
  //   .o_full(full),
	// .o_empty(empty)
  // );


  // always @(*) begin
  //   if(fifo_wr) $display("sum_q = %x\n", sum_q);
  //   if(~fifo_wr && div) $display("sum_this_core = %x\n", sum_this_core);
  // end

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      fifo_wr <= 0;
    end
    else begin
       if (norm) begin

          //  sfp_out_0 <= (abs[bw_psum*1-1 : bw_psum*0] << 4'b1000) / sum_2core;
          //  sfp_out_1 <= (abs[bw_psum*2-1 : bw_psum*1] << 4'b1000) / sum_2core;
          //  sfp_out_2 <= (abs[bw_psum*3-1 : bw_psum*2] << 4'b1000) / sum_2core;
          //  sfp_out_3 <= (abs[bw_psum*4-1 : bw_psum*3] << 4'b1000) / sum_2core;
          //  sfp_out_4 <= (abs[bw_psum*5-1 : bw_psum*4] << 4'b1000) / sum_2core;
          //  sfp_out_5 <= (abs[bw_psum*6-1 : bw_psum*5] << 4'b1000) / sum_2core;
          //  sfp_out_6 <= (abs[bw_psum*7-1 : bw_psum*6] << 4'b1000) / sum_2core;
          //  sfp_out_7 <= (abs[bw_psum*8-1 : bw_psum*7] << 4'b1000) / sum_2core;

           fifo_wr <= 1;
       end
   end
 end


endmodule

