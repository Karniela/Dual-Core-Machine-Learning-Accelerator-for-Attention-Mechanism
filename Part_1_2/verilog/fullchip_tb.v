// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1ns/1ps

module fullchip_tb;

parameter total_cycle = 8;   // how many streamed Q vectors will be processed
parameter bw = 8;            // Q & K vector bit precision
parameter bw_psum = 2*bw+4;  // partial sum bit precision
parameter pr = 8;           // how many products added in each dot product 
parameter col = 8;           // how many dot product units are equipped 

integer qk_file ; // file handler
integer qk_scan_file ; // file handler
integer s_file;
integer out_v_file;

integer  captured_data;
integer  weight [col*pr-1:0];
`define NULL 0




integer  K[col-1:0][pr-1:0];
integer  Q[total_cycle-1:0][pr-1:0];
integer  result[total_cycle-1:0][col-1:0];
integer  sum[total_cycle-1:0];

integer i,j,k,t,p,q,s,u, m;


reg signed [bw_psum-1:0] test = 0;


reg reset = 1;
reg clk = 0;
reg [pr*bw-1:0] mem_in; 
reg ofifo_rd = 0;
wire [19:0] inst; 
reg norm_v_rd = 0;
reg qmem_rd = 0;
reg qmem_wr = 0; 
reg kmem_rd = 0; 
reg kmem_wr = 0;
reg pmem_rd = 0; 
reg pmem_wr = 0; 
reg execute = 0;
reg load = 0;
reg [4:0] qkmem_add = 0;
reg [4:0] pmem_add = 0;
wire [bw_psum*col-1:0] chip_out;

// reg sfp_rd = 0;

assign inst[19] = norm_v_rd;
assign inst[18] = ofifo_rd;
assign inst[17:13] = qkmem_add;
assign inst[12:8]  = pmem_add;
assign inst[7] = execute;
assign inst[6] = load;
assign inst[5] = qmem_rd;
assign inst[4] = qmem_wr;
assign inst[3] = kmem_rd;
assign inst[2] = kmem_wr;
assign inst[1] = pmem_rd;
assign inst[0] = pmem_wr;



reg signed [bw_psum-1:0] temp5b;
reg [bw_psum+3:0] temp_sum;
reg [bw_psum*col-1:0] temp16b;
reg [bw_psum*col-1:0] accumulate_norm_v;


fullchip #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) fullchip_instance (
      .reset(reset),
      .clk(clk), 
      .mem_in(mem_in), 
      .inst(inst),
      .out(chip_out)
);


initial begin 

  $dumpfile("fullchip_tb.vcd");
  $dumpvars(0,fullchip_tb);



///// Q data txt reading /////

$display("##### Q data txt reading #####");


  qk_file = $fopen("qdata.txt", "r");

  // //// To get rid of first 3 lines in data file ////
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);


  for (q=0; q<total_cycle; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          Q[q][j] = captured_data;
          // $display("Q[%d][%d] = %d\n", q, j, Q[q][j]);
    end
  end
/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end




///// K data txt reading /////

$display("##### K data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end
  reset = 0;

  qk_file = $fopen("kdata.txt", "r");

  //// To get rid of first 4 lines in data file ////
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  // qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);




  for (q=0; q<col; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K[q][j] = captured_data;
          // $display("K[%d][%d] = %d\n", q, j, K[q][j]);
    end
  end
/////////////////////////////////








/////////////// Estimated result printing /////////////////


$display("##### Estimated multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     test = 0;
     for (q=0; q<col; q=q+1) begin
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + Q[t][k] * K[q][k];
         end

         temp5b = result[t][q];
         test += (temp5b >= 0) ? temp5b : -temp5b;
        //  $display("t = %d, q = %d, Result = %d\n", t, q, temp5b);
         temp16b = {temp16b[139:0], temp5b};
     end

     //$display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
     $display("prd @cycle%2d: %40h", t, temp16b);
     $display("sum = %d\n", test);
  end

//////////////////////////////////////////////






///// Qmem writing  /////

$display("##### Qmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 clk = 1'b0;  
    qmem_wr = 1;  if (q>0) qkmem_add = qkmem_add + 1; 
    
    mem_in[1*bw-1:0*bw] = Q[q][0];
    mem_in[2*bw-1:1*bw] = Q[q][1];
    mem_in[3*bw-1:2*bw] = Q[q][2];
    mem_in[4*bw-1:3*bw] = Q[q][3];
    mem_in[5*bw-1:4*bw] = Q[q][4];
    mem_in[6*bw-1:5*bw] = Q[q][5];
    mem_in[7*bw-1:6*bw] = Q[q][6];
    mem_in[8*bw-1:7*bw] = Q[q][7];

    #0.5 clk = 1'b1;  

  end


  #0.5 clk = 1'b0;  
  qmem_wr = 0; 
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////





///// Kmem writing  /////

$display("##### Kmem writing #####");

  for (q=0; q<col; q=q+1) begin

    #0.5 clk = 1'b0;  
    kmem_wr = 1; if (q>0) qkmem_add = qkmem_add + 1; 
    
    mem_in[1*bw-1:0*bw] = K[q][0];
    mem_in[2*bw-1:1*bw] = K[q][1];
    mem_in[3*bw-1:2*bw] = K[q][2];
    mem_in[4*bw-1:3*bw] = K[q][3];
    mem_in[5*bw-1:4*bw] = K[q][4];
    mem_in[6*bw-1:5*bw] = K[q][5];
    mem_in[7*bw-1:6*bw] = K[q][6];
    mem_in[8*bw-1:7*bw] = K[q][7];

    #0.5 clk = 1'b1;  

  end

  #0.5 clk = 1'b0;  
  kmem_wr = 0;  
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;   
  end




/////  K data loading  /////
$display("##### K data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    #0.5 clk = 1'b0;  
    load = 1; 
    if (q==1) kmem_rd = 1;
    if (q>1) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  kmem_rd = 0; qkmem_add = 0;
  #0.5 clk = 1'b1;  

  #0.5 clk = 1'b0;  
  load = 0; 
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    execute = 1; 
    qmem_rd = 1;

    if (q>0) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  qmem_rd = 0; qkmem_add = 0; execute = 0;
  #0.5 clk = 1'b1;  


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
 end




////////////// output fifo rd and wb to psum mem ///////////////////

$display("##### move ofifo to pmem #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    ofifo_rd = 1; 
    pmem_wr = 1; 

    if (q>0) begin
       pmem_add = pmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  pmem_wr = 0; pmem_add = 0; ofifo_rd = 0;
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

////////////// Verify result from pmem ///////////////////

$display("##### sfp #####");
#0.5 
  clk = 1'b0;  
  pmem_rd = 1; 
#0.5 
  clk = 1'b1;
  out_v_file = $fopen("sdata_self.txt", "w");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 
      clk = 1'b0;
      pmem_add = pmem_add + 1;
      if(q == total_cycle-1) pmem_rd = 0;
      $display("SFP %d output = %x\n", q, chip_out);
      for(j=pr-1; j>=0; j=j-1) begin
        $fwrite(out_v_file, "%d", chip_out[(j+1)*bw_psum-1-:bw_psum]);
      end
      $fwrite(out_v_file, "\n");
    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
      $fclose(out_v_file);
      pmem_add = 0;
  #0.5 clk = 1'b1;  

/////////////////////////////////////////

////////////// Verify result from pmem ///////////////////

// $display("##### Verify result from pmem  #####");
// #0.5 
//   clk = 1'b0;  
//   sfp_rd = 1; 
//   pmem_rd = 1;
// #0.5 
//   clk = 1'b1;

//   for (q=0; q<total_cycle; q=q+1) begin

//     #0.5 
//       clk = 1'b0;
//       pmem_add = pmem_add + 1;
//       if(q == total_cycle-1) pmem_rd = 0;
//     #0.5 clk = 1'b1;  
//     $display("Verifying sfp out %d = %x\n", q, chip_out);
//   end

//   #0.5 clk = 1'b0;  
//   sfp_rd = 0; pmem_add = 0;
//   #0.5 clk = 1'b1;  

///////////////////////////////////////////










$display("##### V data txt reading #####");
qk_file = $fopen("vdata.txt", "r");

for (q=0; q<total_cycle; q=q+1) begin
  for (j=0; j<pr; j=j+1) begin
        qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
        Q[j][q] = captured_data;
        $display("Q[%d][%d] = %d\n", j, q, Q[j][q]);
  end
end

for (q=0; q<2; q=q+1) begin
  #0.5 clk = 1'b0;   
  #0.5 clk = 1'b1;   
end

s_file = $fopen("sdata_self.txt", "r");
for (m=0; m<total_cycle; m=m+1) begin
  ///// vdata txt reading /////
  #0.5 
    clk = 1'b0;
    reset = 1'b1;
  #0.5 
    clk = 1'b1;
  #0.5 
    clk = 1'b0;
    reset = 1'b0;
  #0.5
    clk = 1'b1;
  //// sdata txt reading /////

  $display("##### S data txt reading #####");

    for (q=0; q<10; q=q+1) begin
      #0.5 clk = 1'b0;   
      #0.5 clk = 1'b1;   
    end
    reset = 0;


    for (j=0; j<pr; j=j+1) begin
      qk_scan_file = $fscanf(s_file, "%d", captured_data);
      K[0][j] = captured_data;
    end

    for (q=1; q<col; q=q+1) begin
      for (j=0; j<pr; j=j+1) begin
          K[q][j] = 0;
      end
    end
    for (q=0; q<col; q=q+1) begin
      for (j=0; j<pr; j=j+1) begin
          $display("K[%d][%d] = %d\n", q, j, K[q][j]);
      end
    end

  /////////////// Estimated result printing /////////////////

  $display("##### Estimated multiplication result #####");

    for (t=0; t<total_cycle; t=t+1) begin
      for (q=0; q<col; q=q+1) begin
        result[t][q] = 0;
      end
    end

    for (t=0; t<total_cycle; t=t+1) begin
      test = 0;
      for (q=0; q<col; q=q+1) begin
          for (k=0; k<pr; k=k+1) begin
              result[t][q] = result[t][q] + Q[t][k] * K[q][k];
          end

          temp5b = result[t][q];
          test += (temp5b >= 0) ? temp5b : -temp5b;
          //  $display("t = %d, q = %d, Result = %d\n", t, q, temp5b);
          temp16b = {temp16b[139:0], temp5b};
      end

      //$display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
      $display("prd @cycle%2d: %40h", t, temp16b);
      //  $display("sum = %d\n", test);
    end

  ///// Qmem writing  /////

  $display("##### Qmem writing (V data) #####");

    for (q=0; q<total_cycle; q=q+1) begin

      #0.5 clk = 1'b0;  
      qmem_wr = 1;  if (q>0) qkmem_add = qkmem_add + 1; 
      
      mem_in[1*bw-1:0*bw] = Q[q][0];
      mem_in[2*bw-1:1*bw] = Q[q][1];
      mem_in[3*bw-1:2*bw] = Q[q][2];
      mem_in[4*bw-1:3*bw] = Q[q][3];
      mem_in[5*bw-1:4*bw] = Q[q][4];
      mem_in[6*bw-1:5*bw] = Q[q][5];
      mem_in[7*bw-1:6*bw] = Q[q][6];
      mem_in[8*bw-1:7*bw] = Q[q][7];

      #0.5 clk = 1'b1;  

    end


    #0.5 clk = 1'b0;  
    qmem_wr = 0; 
    qkmem_add = 0;
    #0.5 clk = 1'b1;  

  ///// Kmem writing  /////

  $display("##### Kmem writing (S data)#####");

    for (q=0; q<col; q=q+1) begin

      #0.5 clk = 1'b0;  
      kmem_wr = 1; if (q>0) qkmem_add = qkmem_add + 1; 
      
      mem_in[1*bw-1:0*bw] = K[q][0];
      mem_in[2*bw-1:1*bw] = K[q][1];
      mem_in[3*bw-1:2*bw] = K[q][2];
      mem_in[4*bw-1:3*bw] = K[q][3];
      mem_in[5*bw-1:4*bw] = K[q][4];
      mem_in[6*bw-1:5*bw] = K[q][5];
      mem_in[7*bw-1:6*bw] = K[q][6];
      mem_in[8*bw-1:7*bw] = K[q][7];

      #0.5 clk = 1'b1;  

    end

    #0.5 clk = 1'b0;  
    kmem_wr = 0;  
    qkmem_add = 0;
    #0.5 clk = 1'b1;  
  ///////////////////////////////////////////



    for (q=0; q<2; q=q+1) begin
      #0.5 clk = 1'b0;  
      #0.5 clk = 1'b1;   
    end

  /////  S data loading  /////
  $display("##### S data loading to processor #####");

    for (q=0; q<col+1; q=q+1) begin
      #0.5 clk = 1'b0;  
      load = 1; 
      if (q==1) kmem_rd = 1;
      if (q>1) begin
        qkmem_add = qkmem_add + 1;
      end

      #0.5 clk = 1'b1;  
    end

    #0.5 clk = 1'b0;  
    kmem_rd = 0; qkmem_add = 0;
    #0.5 clk = 1'b1;  

    #0.5 clk = 1'b0;  
    load = 0; 
    #0.5 clk = 1'b1;  

  ///////////////////////////////////////////

  for (q=0; q<10; q=q+1) begin
      #0.5 clk = 1'b0;   
      #0.5 clk = 1'b1;   
  end

  ///// execution  /////
  $display("##### execute #####");

    for (q=0; q<total_cycle; q=q+1) begin
      #0.5 clk = 1'b0;  
      execute = 1; 
      qmem_rd = 1;

      if (q>0) begin
        qkmem_add = qkmem_add + 1;
      end

      #0.5 clk = 1'b1;  
    end

    #0.5 clk = 1'b0;  
    qmem_rd = 0; qkmem_add = 0; execute = 0;
    #0.5 clk = 1'b1;  


  ///////////////////////////////////////////

  for (q=0; q<10; q=q+1) begin
      #0.5 clk = 1'b0;   
      #0.5 clk = 1'b1;   
  end

  ////////////// output fifo rd and wb to psum mem ///////////////////

  $display("##### move ofifo to pmem #####");

    for (q=0; q<total_cycle; q=q+1) begin
      #0.5 clk = 1'b0;  
      ofifo_rd = 1; 
      pmem_wr = 1; 

      if (q>0) begin
        pmem_add = pmem_add + 1;
      end

      #0.5 clk = 1'b1;  
    end

    #0.5 clk = 1'b0;  
    pmem_wr = 0; pmem_add = 0; ofifo_rd = 0;
    #0.5 clk = 1'b1;  

  ///////////////////////////////////////////

  ////////////// Verify result from pmem ///////////////////

  $display("##### Verify norm * v #####");
  #0.5 
    clk = 1'b0;  
    pmem_rd = 1; 
    norm_v_rd = 1;
  #0.5 
    clk = 1'b1;
    // out_v_file = $fopen("s_data_self.txt", "w");

    for (q=0; q<total_cycle; q=q+1) begin

      #0.5 
        clk = 1'b0;
        pmem_add = pmem_add + 1;
        if(q == total_cycle-1) pmem_rd = 0;
        accumulate_norm_v = {accumulate_norm_v[bw_psum*(col-1)-1:0], chip_out[bw_psum*col-1:bw_psum*(col-1)]};
        // $display("norm * v %d output = %x\n", q, chip_out);
        // for(j=pr-1; j>=0; j=j-1) begin
        //   $fwrite(out_v_file, "%d ", chip_out[(j+1)*bw_psum-1-:bw_psum]);
        // end
        // $fwrite(out_v_file, "\n");
      #0.5 clk = 1'b1;  
    end

    #0.5 clk = 1'b0;  
        pmem_add = 0;
        $display("norm * v %d output = %x\n", q, accumulate_norm_v);
    #0.5 clk = 1'b1;  
end

#10 $finish;
end

endmodule




