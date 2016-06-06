# zynq-axi-tutorial

This is a tutorial on the usage of AMBA AXI interfaces with HW accelerators derived through High-Level Synthesis (HLS) in the IP form. Specifically, the AXI4-Lite and AXI4-Stream interfaces are examined. Our target device is Zynq-7000 APSoC and particularly, the Zedboard.

## Generating HW Accelerators through HLS

The flow of this tutorial begins with the generation of custom IPs through Vivado HLS 2014.4. We employ a very simple example as our source code. Specifically, an integer is given as input to the HW module and the result is this integer increased by one. The simplicity of the code is considered essential as a first approach to the explanation of the operating principles of AXI protocols. In /hls directory, three files make their appearance. For C-Simulation, C-Synthesis and IP-extraction alltogether open a terminal and run

```bash
vivado_hls -f create_add_one.tcl
```

This command automatically creates two different versions of the add_one IP, a version with AXI4-Lite interfaces and another version with AXI4-Stream interfaces. The IP-extraction is now completed. If you wish, you may create a new Vivado HLS project, add the source code and necessary directives and manually run the C-simulation, C-synthesis and IP-extraction before proceeding to the next step.

## System Generation

For the next step of our implementation Vivado Design Suite 2014.4 is utilized. The IPs that were extracted during the previous step should now be added to an IP repository and subsequently to our design. AXI4-Lite and AXI4-Stream interfaces require different components in order to be interconnected with the ZYNQ-7 Processing System. 

### AXI4-Lite Interface

In case of an IP with an AXI4-Lite interface the interconnection with the PS is for the most part automated and the Synthesis, Implementation and Bitstream Generation steps may follow. 

### AXI4-Stream Interface

For an IP with AXI4-Stream interfaces the interconnection process is not as automated as in the previous case. AXI4-Stream peripherals require the addition of AXI DMA IPs.
