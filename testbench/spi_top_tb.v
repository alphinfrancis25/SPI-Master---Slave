`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 15:29:22
// Design Name: 
// Module Name: spi_top_tb
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


module spi_top_tb();

  reg clk, reset, start, cs;
  reg [7:0] master_din, slave_din;
  wire [7:0] master_dout, slave_dout;

  spi_top DUT (
    .clk(clk),
    .reset(reset),
    .start(start),
    .master_din(master_din),
    .slave_din(slave_din),
    .master_dout(master_dout),
    .slave_dout(slave_dout)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz
  end

  initial begin
    $dumpfile("spi_top.vcd");
    $dumpvars(0, spi_top_tb);
    $monitor("Time=%0t master_din=%b slave_din=%b master_dout=%b slave_dout=%b",
              $time, master_din, slave_din, master_dout, slave_dout);
  end

  initial begin
    reset = 1;
    start = 0;
    master_din = 8'b10101010; // what master sends
    slave_din  = 8'b11001100; // what slave sends
    #50 reset = 0;

    #100 start = 1;
    #10  start = 0;

    @(posedge cs);  // Sync to CS high (end of transfer)
    #50;
    if (master_dout == slave_din && slave_dout == master_din)
      $display(" SPI Transfer Successful!");
    else
      $display("SPI Transfer Failed!");

   $finish(1000);
  end

endmodule
