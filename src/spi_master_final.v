module spi_master_final(clk,reset,sclk,DIN,MISO,MOSI,cs,start,DOUT);
  input clk, reset ; 
  input MISO, start ;
  input [7:0] DIN ;
  output reg sclk ; 
  output reg MOSI = 0 ;
  output reg cs ;
  output reg [7:0] DOUT = 0 ;
  
  reg [1:0] STATE ;
  reg [7:0] TX_reg ;
  reg [7:0] RX_reg ;
  reg [3:0] COUNT_BIT ;
  reg [3:0] clk_div ;
  
  localparam IDLE = 2'b00 , TRANSFER = 2'b01 , STOP = 2'b10;
  
  
    always @(posedge clk or posedge reset) begin
      if (reset) begin
        sclk <= 1'b0;
        clk_div <= 4'b0000;
      end else if (STATE != TRANSFER) begin  // Pause in IDLE/STOP (your change, good)
        sclk <= 1'b0;
        clk_div <= 4'b0000;
      end else begin  // TRANSFER: Normal divide, but force first toggle
        if (COUNT_BIT == 0 && clk_div == 0) begin  // First cycle after entry (COUNT_BIT=0 initial)
          sclk <= ~sclk;  // Force immediate toggle (to neg if low)
          clk_div <= 4'b0001;  // Start count from 1 for next
        end else if (clk_div == 4'b0100) begin
          sclk <= ~sclk;
          clk_div <= 4'b0000;
        end else
          clk_div <= clk_div + 4'b0001;
      end
    end
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          STATE <= IDLE ;
          cs <= 1'b1 ;
          COUNT_BIT <= 4'b0000 ;
          RX_reg <= 8'b0 ;
          TX_reg <= 8'b0 ;
        end
      else
        begin
          case(STATE)
            IDLE :
              
              begin
                if(start)
                  begin
                    cs <= 1'b0 ;
                    TX_reg <= DIN ;
                    COUNT_BIT <= 4'b0000 ;
                    RX_reg <= 8'b0 ;
                    STATE <= TRANSFER ;
                    MOSI <= DIN[7] ;
                  end
                else
                  begin
                    cs <= 1'b1 ;
                  end
              end
     
         
            STOP :
              
              begin
                STATE <= IDLE ; 
                DOUT <= RX_reg ;
                COUNT_BIT <= 4'b0000 ;                
              end
            
          endcase
        end
    end
  
            
            
  
  always @(negedge sclk)
    begin
      if(STATE == TRANSFER)
        begin
          MOSI <= TX_reg[7] ;
          TX_reg <= { TX_reg[6:0],1'b0 } ;
        end
    end
  
  always @(posedge sclk)
    begin
      if(STATE == TRANSFER)
        begin
          RX_reg <= {RX_reg[6:0], MISO};
          COUNT_BIT <= COUNT_BIT + 1 ;
          if(COUNT_BIT == 4'd8)
           begin
            STATE <= STOP ;
           end 
        end
    end
  
      
  
endmodule
