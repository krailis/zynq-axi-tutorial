# zynq-axi-tutorial

This is a tutorial on the usage of AMBA AXI interfaces with HW accelerators derived through High-Level Synthesis (HLS) in the IP form. Specifically, the AXI4-Lite and AXI4-Stream interfaces are examined. Our target device is Zynq-7000 APSoC and particularly, the Zedboard.

## Generating HW Accelerators through HLS

The flow of this tutorial begins with the generation of custom IPs through Vivado HLS 2014.4. We employ a very simple example as our source code. Specifically, an integer is given as input to the HW module and the result is this integer increased by one. The simplicity of the code is considered essential as a first approach to the explanation of the operating principles of AXI protocols. In /hls directory, three files make their appearance. For C-Simulation, C-Synthesis and IP-extraction alltogether open a terminal and run

```bash
vivado_hls -f create_add_one.tcl
```

This command automatically creates two different versions of the add_one IP, a version with AXI4-Lite interfaces and another version with AXI4-Stream interfaces. The IP-extraction is now completed. If you wish, you may add create a new Vivado HLS project, add the source code and necessary directives and manually run the C-simulation, C-synthesis and IP-extraction before proceeding to the next step.
