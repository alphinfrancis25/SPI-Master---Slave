# SPI-Master---Slave
This project implements a basic SPI master and slave using Verilog. It supports 8-bit full-duplex data transfer between the two devices.

Features

*8-bit full-duplex transfer
*Master controls SCLK and CS
*Data shifted on MOSI and MISO lines
*Master FSM: IDLE → TRANSFER → STOP
*Slave detects frame completion using the chip select
*Final received data (DOUT/dout) updates only after a full frame

