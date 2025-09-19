# SPI-Master---Slave
This project implements a basic SPI master and slave using Verilog. It supports 8-bit full-duplex data transfer between the two devices.

Features

1. 8-bit full-duplex transfer
2. Master controls SCLK and CS
3. Data shifted on MOSI and MISO lines
4. Master FSM: IDLE → TRANSFER → STOP
5. Slave detects frame completion using the chip select
6. Final received data (DOUT/dout) updates only after a full frame

