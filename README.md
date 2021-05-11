# AXI DMA Master verification

#### SUMMARY
This is an UVM verification environment for an AXI DMA master core. The agents provide randomized AXI slave responses to interact with an AXI master, and they could be configured to generates data of various size, address, and burst type. Also, the response delay could be set up and randomized by configuring the minimum-value, maximum-value, long-, mid-, and short-weights.


**Overview of the UVM agents**

![Image of Boxes](https://raw.githubusercontent.com/letitbe0201/AXI-DMA-master-verification/master/doc/test_env.jpg)


**Waveforms:**
Read buffer: 32-bit
Transfer buffer: 64-bit
No delay
![Image of Boxes](https://raw.githubusercontent.com/letitbe0201/AXI-DMA-master-verification/master/doc/standard_tras_32_64.jpg)

Read buffer: 32-bit
Transfer buffer: 64-bit
Min-delay:0
Max_delay:10
Weight(0, short, long): 6, 3, 1
![Image of Boxes](https://raw.githubusercontent.com/letitbe0201/AXI-DMA-master-verification/master/doc/delay_tras_32_64_axi.jpg)

**Poster**(https://github.com/letitbe0201/AXI-DMA-master-verification/blob/master/doc/poster.pdf)