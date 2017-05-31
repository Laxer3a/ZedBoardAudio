# ZedBoardAudio - AXI Slave Audio Component.

# Project
This project is a AXI Slave component for the ADAU1761.

It is using the project done by HamsterWorks at :
http://hamsterworks.co.nz/mediawiki/index.php/Zedboard_Audio

This project takes the logic, removes the filters from the design,
add dual clock domain FIFO (one for the ADC, one for the DAC),
and finally did a basic AXI Slave.

See HamsterWorks URL given earlier for implementation detail.
(I will put a zip in case the web site disappear)



And create a AXI Slave, allowing the CPU to send audio data directly to the ADAU1761 Audio Codec.

Because Vivado sucks, copy files all around, do things that even god doesn't know why.
I decided to put the files and let the user integrate those :
- The inner VHDL files are provided.
- The constraint file are provided.
- The AXI Slave files are provided.

# Steps
(I am currently using Vivado 2016.4 but I will try to make the instructions followable on any other platform)

## Importing IP ##

1. Launch Vivado
2. Create a new RTL project
3. Skip until Add Constraint Files, then select "constraintAudio.xdc"
	This file is for Zedboard pin setup.
4. It ask for the boards, select ZedBoard.
5. Finish

## Instancing and connect IP ##

Inside the project.
1. Project Settings -> IP -> Repository Manager -> "+" (Add path)
2. Select the root folder of this GIT repository.
3. Click Apply, then OK.
4. Create a new Block Design, then "Add IP"
Search for "Audio", select "AudioInOut16"
5. Then "Add IP" again, add a Zynq processing system.
Now we have the CPU and the slave, let the system connect everything for us.
6. Right click on design, "Run Block Automation"
7. Right click on design, "Run Connection Automation"
8. Now we have to create the PIN for the ADAU1761.
9. (Right click, "Create Port" multiple times)
- OUT PINS   : AC_GPIO0, AC_ADR0, AC_ADR1, AC_MCLK, AC_SCK.
- INOUT PINS : AC_SDA.
- IN PINS    : CLK_100, AC_GPIO1, AC_GPIO2, AC_GPIO3.
	
10. Connect all pins to AudioInOut16
11. Now remain IRQ.
For now current implement does not send IRQ (set to 0).
Not connected inside the design should not a problem, if trouble,
just setup the "Processing System 7" IP to authorize PL to PS interrupt.

	[Do not forget to save]
	
## Building and synthesis ##

1. Select your design in the Hierarchy tab. Right click, create HDL Wrapper.
2. Launch Generate Bitstream. (It will do RTL, Synthesis, Implementation and Generate Bitstream)
3. Follow the flow.
4. Upload the bitstream to the FPGA. (I won't detail that...)

## Design Note ##
- IRQ is not implemented yet.
I have tested with IRQ not connect and got no build issues.
- We use 2048 sample buffer into the ADC and DAC FIFO.
(if you do not plan to let the buffer fill completly you can lower the latency,
in other term, read and write very quickly with the CPU)
- See programming section.
- FIFO Store the audio data in signed 16 bit format.
- ADAU1761 receive the data in 24 bit format. So we upsize (FIFO->DAC) and downsize (ADC->FIFO) the data.
Feel free to modify the Slave architecture.
- DAC and ADC FIFO are 32 bit wide, storing LEFT and RIGHT samples together inside one FIFO entry.
MSB is RIGHT.
LSB is LEFT.

Write Register at base adress (0x43C0_0000 by default) +4 to push data to the DAC.
Read  Register at base adress (0x43C0_0000 by default) +8 to read data from the ADC.

- Default AXI Slave design has to 16 registers. As +0,+4,+8 only are used, there are still space
to add other register for your specific needs.
  
# Schematics
![System Schematics](/SchematicsAudio.png)

# Programming

Note : the import created a default adress @0x43C0_0000 for the Audio Slave Device.

Let's use a macro like :
	
```
volatile u32* AUDIOCHIP = ((volatile u32*)0x430C0000);
```
	
## Registers :

Register +0 - WRITE :
	Bit 0 Write : Perform Reset DAC Fifo. (1:Do it)
	Bit 1 Write : Perform Reset ADC Fifo. (1:Do it)
	
Register +0 - READ :
	Bit 2 Read  : ADC Fifo Empty (1:True, 0:False)
	Bit 3 Read  : DAC Fifo Empty (1:True, 0:False)
	Bit 4 Read  : ADC Fifo Full  (1:True, 0:False)
	Bit 5 Read  : DAC Fifo Full  (1:True, 0:False)

Register +4 - WRITE :
	Push data to DAC FIFO.
	
Register +8 - READ  :
	Pop data from ADC FIFO.
	
## Sample program :

```
volatile u32* AUDIOCHIP = ((volatile u32*)0x430C0000);
AUDIOCHIP[0] = 3; // Reset FIFOs.

while (1) {
	// WAIT FOR DAC FIFO TO BE EMPTY.
	if ((AUDIOCHIP[0] & 1<<3)!=0) {
		// Transmit Line-In to HP Out.
		AUDIOCHIP[1] = AUDIOCHIP[2];
	}
}
```
	
## SDK, How to : 

As usual, from Vivado, File->Export->Hardware.
Then inside SDK tool, create New Application Project,
do your thing (name, location, ...)
Select the already present Hardware Platform.
C Language,
Create new Board Support package.
Next, "Hello World" Application sample. (will create the main.c)

Copy the sample program after 

```
initPlatform();
```

inside the main function of helloWorld.c

Build, run as usual. (I won't describe here either).

You should hear your line in into speaker.
You can check by doing something like AUDIOCHIP[2] & 0xFFFF0000;
to select only the RIGHT channel.

