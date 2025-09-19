`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 15:28:20
// Design Name: 
// Module Name: spi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_top(
  input clk,
  input start,
  input reset,
  input [7:0] master_din,
  input [7:0] slave_din,
  output [7:0] master_dout,
  output [7:0] slave_dout 
);
  
  wire sclk, cs, mosi, miso ;
  
  spi_master_final spi_master_init(
    .clk(clk),
    .reset(reset),
    .sclk(sclk),
    .DIN(master_din),
    .MISO(miso),
    .MOSI(mosi),
    .cs(cs),
    .start(start),
    .DOUT(master_dout)
  );
  
  
  spi_slave_final spi_slave_init(
    .sclk(sclk),
    .cs(cs),
    .mosi(mosi),
    .reset(reset),
    .miso(miso),
    .dout(slave_dout),
    .din(slave_din)
  );
  
  
endmodule
