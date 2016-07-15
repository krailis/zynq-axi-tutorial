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

In case of an IP with an AXI4-Lite interface the interconnection with the PS is for the most part automated and the Synthesis, Implementation and Bitstream Generation steps may follow. Vivado automatically adds an AXI Interconnect Block and a Processor System Reset. The IRQ_F2P port of the ZYNQ should be enabled in order to receive interrupts from our custom AXI4-Lite IP. For the automatic generation of a project including a block design, ready to be synthesized and implemented open a terminal, change the directory to /zedboard_axi4lite and run the command

```bash
vivado -mode tcl -source create_add_one_axi4lite.tcl
```

Vivado will launch, a project will be created followed by the creation of a block design. After this step you may select Generate Bitstream. A pop-up window will inform you that you need to run the Synthesis and Implementation steps first. Choose 'yes' and wait for the process to be completed. Finally, choose File->Export->Export Hardware and make sure that the 'Include Bitstream' option is selected.


### AXI4-Stream Interface

For an IP with AXI4-Stream interfaces the interconnection process is partially automated in comparison with the previous case. AXI4-Stream peripherals require the manual addition and re-configuration of AXI DMA IP Blocks. The AXI DMA IP performs as both slave and master to the ZYNQ-7 Processing System. Vivado automatically adds components similarly to the AXI4-Lite case. An additional component is an AXI Memory Interconnect Block for the AXI DMA to handle the main memory through ZYNQ's High-Performance Slave Port. For the generation of this version of the system change the directory to /zedboard_axi4stream and run the command

```bash
vivado -mode tcl -source create_add_one_axi4stream.tcl
```

Then, follow the steps described for AXI4-Lite interface in order to generate the bitstream file. Some minor warnings might make their appearance but you may ignore them.

## Generation of Custom Linux Distributions

Having generated the bitstream for our target device, the next step is to create a Linux Distribution for our hardware which will now include our custom IPs. For this purpose PetaLinux Tools 2014.4 were employed. Change the directory to the clonned project and execute the command

```bash
petalinux-create -t project --name peta_add_one
```

Then change the directory to zedboard_axi4lite/zedboard_axi4lite.sdk or zedboard_axi4stream/zedboard_axi4stream.sdk depending on which version you wish to test. Now run the command

```bash
petalinux-config --get-hw-description -p ../../peta_add_one
```

The tool will extract the hardware description. You should then choose 'exit' in the prompt that follows. At this point a device-tree including our custom IPs will have been produced in the directory peta_add_one/subsystems/linux/configs/device-tree. For the AXI4-Lite version our custom accelerator should be compatible with the Linux UIO Framework in order to be easily accessed from a userspace application. For this purpose the system-top.dts file in the aforementioned directory should be replaced with the system-top.dts file from the petalinux_device-tree_patch folder. For the AXI4-Stream version no additional actions are required and the file should not be replaced. Then we are ready to build the Linux distribution by running the command

```bash
petalinux-build
```

while inside the /peta_add_one directory. When Linux is built change your directory to images/linux. Now run the command

```bash
petalinux-package --boot --fsbl zynq_fsbl.elf --fpga ../../../zedboard_axi4lite/zedboard_axi4lite.runs/impl_1/system_wrapper.bit --uboot
```
or

```bash
petalinux-package --boot --fsbl zynq_fsbl.elf --fpga ../../../zedboard_axi4stream/zedboard_axi4stream.runs/impl_1/system_wrapper.bit --uboot
```

depending on the desired version of the system. A BOOT.BIN file will be created. In order for the ZedBoard to be booted with Linux, the BOOT.BIN file along with the image.ub file should be copied to the SD card.
