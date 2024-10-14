// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sram_w32 (CLK, D, Q, CEN, WEN, A);

  parameter sram_bit = 128;
  input  CLK;
  input  WEN;
  input  CEN;
  input  [sram_bit-1:0] D;
  input  [4:0] A;
  output reg [sram_bit-1:0] Q;

  reg [sram_bit-1:0] memory0;
  reg [sram_bit-1:0] memory1;
  reg [sram_bit-1:0] memory2;
  reg [sram_bit-1:0] memory3;
  reg [sram_bit-1:0] memory4;
  reg [sram_bit-1:0] memory5;
  reg [sram_bit-1:0] memory6;
  reg [sram_bit-1:0] memory7;
  reg [sram_bit-1:0] memory8;
  reg [sram_bit-1:0] memory9;
  reg [sram_bit-1:0] memory10;
  reg [sram_bit-1:0] memory11;
  reg [sram_bit-1:0] memory12;
  reg [sram_bit-1:0] memory13;
  reg [sram_bit-1:0] memory14;
  reg [sram_bit-1:0] memory15;
  reg [sram_bit-1:0] memory16;
  reg [sram_bit-1:0] memory17;
  reg [sram_bit-1:0] memory18;
  reg [sram_bit-1:0] memory19;
  reg [sram_bit-1:0] memory20;
  reg [sram_bit-1:0] memory21;
  reg [sram_bit-1:0] memory22;
  reg [sram_bit-1:0] memory23;
  reg [sram_bit-1:0] memory24;
  reg [sram_bit-1:0] memory25;
  reg [sram_bit-1:0] memory26;
  reg [sram_bit-1:0] memory27;
  reg [sram_bit-1:0] memory28;
  reg [sram_bit-1:0] memory29;
  reg [sram_bit-1:0] memory30;
  reg [sram_bit-1:0] memory31;

/*
  assign Q = (add_q == 0)  ? memory0 : (
             (add_q == 1)  ? memory1 : (
             (add_q == 2)  ? memory2 : (
             (add_q == 3)  ? memory3 : (
             (add_q == 4)  ? memory4 : (
             (add_q == 5)  ? memory5 : (
             (add_q == 6)  ? memory6 : (
             (add_q == 7)  ? memory7 : (
             (add_q == 8)  ? memory8 : (
             (add_q == 9)  ? memory9 : (
             (add_q == 10) ? memory10 : (
             (add_q == 11) ? memory11 : (
             (add_q == 12) ? memory12 : (
             (add_q == 13) ? memory13 : (
             (add_q == 14) ? memory14 : memory15))))))))))))));
*/

  always @ (posedge CLK) begin

   if (!CEN && WEN) begin // read 
     case (A)
      5'b00000: Q <= memory0; 
      5'b00001: Q <= memory1; 
      5'b00010: Q <= memory2; 
      5'b00011: Q <= memory3; 
      5'b00100: Q <= memory4; 
      5'b00101: Q <= memory5; 
      5'b00110: Q <= memory6; 
      5'b00111: Q <= memory7; 
      5'b01000: Q <= memory8; 
      5'b01001: Q <= memory9; 
      5'b01010: Q <= memory10; 
      5'b01011: Q <= memory11; 
      5'b01100: Q <= memory12; 
      5'b01101: Q <= memory13; 
      5'b01110: Q <= memory14; 
      5'b01111: Q <= memory15; 
      5'b10000: Q <= memory16; 
      5'b10001: Q <= memory17; 
      5'b10010: Q <= memory18; 
      5'b10011: Q <= memory19; 
      5'b10100: Q <= memory20; 
      5'b10101: Q <= memory21; 
      5'b10110: Q <= memory22; 
      5'b10111: Q <= memory23; 
      5'b11000: Q <= memory24; 
      5'b11001: Q <= memory25; 
      5'b11010: Q <= memory26; 
      5'b11011: Q <= memory27; 
      5'b11100: Q <= memory28; 
      5'b11101: Q <= memory29; 
      5'b11110: Q <= memory30; 
      5'b11111: Q <= memory31; 
    endcase
   end

   else if (!CEN && !WEN) begin // write
     case (A)
      5'b00000: memory0  <= D; 
      5'b00001: memory1  <= D; 
      5'b00010: memory2  <= D; 
      5'b00011: memory3  <= D; 
      5'b00100: memory4  <= D; 
      5'b00101: memory5  <= D; 
      5'b00110: memory6  <= D; 
      5'b00111: memory7  <= D; 
      5'b01000: memory8  <= D; 
      5'b01001: memory9  <= D; 
      5'b01010: memory10 <= D; 
      5'b01011: memory11 <= D; 
      5'b01100: memory12 <= D; 
      5'b01101: memory13 <= D; 
      5'b01110: memory14 <= D; 
      5'b01111: memory15 <= D; 
      5'b10000: memory16 <= D; 
      5'b10001: memory17 <= D; 
      5'b10010: memory18 <= D; 
      5'b10011: memory19 <= D; 
      5'b10100: memory20 <= D; 
      5'b10101: memory21 <= D; 
      5'b10110: memory22 <= D; 
      5'b10111: memory23 <= D; 
      5'b11000: memory24 <= D; 
      5'b11001: memory25 <= D; 
      5'b11010: memory26 <= D; 
      5'b11011: memory27 <= D; 
      5'b11100: memory28 <= D; 
      5'b11101: memory29 <= D; 
      5'b11110: memory30 <= D; 
      5'b11111: memory31 <= D; 
    endcase
  end
end

endmodule
