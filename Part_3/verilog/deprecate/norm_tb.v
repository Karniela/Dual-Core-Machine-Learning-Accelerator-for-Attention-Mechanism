// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module norm_tb;

parameter bw = 4;
parameter total_cycle = 8;

reg clk = 0;
reg div = 0;
reg wr = 0;
reg  reset = 0;
reg [bw-1:0] w_vector_bin;
wire [2*bw-1:0] out;
wire full, ready;

integer w_file ; // file handler
integer w_scan_file ; // file handler
integer captured_data;
reg [bw-1:0] binary;
integer i; 
integer u; 

integer  w[total_cycle-1:0];



function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction


norm #(.bw(bw)) norm_instance (
        .clk(clk),
        .in(binary), 
        .out(out), 
        .div(div),
        .wr(wr), 
        .reset(reset) 
);

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data

  $dumpfile("norm_tb.vcd");
  $dumpvars(0,norm_tb);
 
  #1 clk = 1'b0; reset = 1;
  #1 clk = 1'b1; 
  #1 clk = 1'b0; reset = 0; 
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  
  wr = 1;
  for (i=0; i<total_cycle; i=i+1) begin

     w_scan_file = $fscanf(w_file, "%d\n", captured_data);
     w[i] = captured_data;
     $display("======w[%d] = %d=====\n", i, w[i]);
     binary = w_bin(w[i]);  

     #1 clk = 1'b1;
     #1 clk = 1'b0;

  end

  wr = 0;
  #1 clk = 1'b1;
  #1 clk = 1'b0;
  

  
  for (i=0; i<total_cycle; i=i+1) begin     
	div = 1'b1;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	div = 1'b0;
	$display("=====Data %d = %d=====\n", i, out);
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
  end

		

  #10 $finish;


end

endmodule





