`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2025 16:36:35
// Design Name: 
// Module Name: spi_slave
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


module spi_slave_final(sclk,cs,mosi,reset,miso,dout,din);
  input sclk , cs , mosi , reset;
  input [7:0] din ;
  output reg miso = 0 ;
  output reg [7:0] dout ;
  
  
  reg [3:0] bit_count ;
  reg [7:0] tx_reg ;
  reg [7:0] rx_reg ;
  

  
  reg frame_done ;
  
  always @(posedge sclk , posedge reset)
    begin
      if(reset)
        begin
          bit_count <= 0 ;
          rx_reg <= 8'b0 ;
          dout <= 8'b0 ;
          frame_done <= 1'b0 ;
        end
      else if(!cs && !frame_done)
        begin
          rx_reg <= {rx_reg[6:0], mosi};
          bit_count <= bit_count + 1 ;
          
          if (bit_count == 8)
            begin
              frame_done <= 1'b1 ;
            end         
        end
 
      else if (cs)
        begin
          
          frame_done <= 1'b0 ;
          bit_count <= 0;
        end        
                
    end
  
  always @(negedge sclk , posedge reset)
    begin
      if(reset)
        begin
          tx_reg <= 8'b0 ;
          
        end
      else if(!cs && !frame_done && bit_count >0)
        begin
          miso <= tx_reg[7] ;
          tx_reg <= {tx_reg[6:0],1'b0} ;
        end
      else if(bit_count == 1)  
        tx_reg <= {tx_reg[6:0], 1'b0};
    end
  
  always @(negedge cs )
    begin
       tx_reg <= din ;
       //frame_done <= 1'b0 ;
       miso <= din[7];
    end
  always @(posedge frame_done)begin
    dout <= rx_reg ;
    end
     
endmodule
