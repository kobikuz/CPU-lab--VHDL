VHD files and brief functional description

AdderSub.vhd:
#This is the File that was given to us so we can use it in Procces2#
input: 
	a,b as an n-bit vector cin a  bit.
output: 
	S as an n-bit vector and cout  as a single bit.

functional: 
	consist of n FA's for each bit. Takes a and b signals
	and perform addition.
	we know we can utilize this modul for subtraction if we input cin=1 and instead of b we will input not(b).

top.vhd:
The top entity  which will include the three procceses of the Lab:
inputs: 
	rst,ena and clk as bits. - all those for the timing of the 	  machine.These will connect only to the synchronized procceses which are 1 and 3.
	x- a n bit(generalized) vector.
	Dectection code - an integer in range of 0 to 3. which will decide what is the  wanted distance of the inputs that we want to detect in procces2.
output:
	detector - a single bit. If it equals '1' means that we have the desired distance of the input samples for m(generelized number) consecutive times.
functional:
		concsists of 3 procceses:
			procces1: a synchronized procces which samples the input X when recieves a clocks and ena '1' bits. the procces than delays the sample by one clk period. giving the output of X[j-1] and X[j-2].
			
			procces2: a non-synchronized procces. it recieves the outputs of procces1 and a DetectionCode . the DetectionCode is responsible for letting the proccesknow what distance between the two inputs we are looking for .
			the process then compares the inputs and checks if the distance condition is ture, if so- the output (named valid) will be '1', otherswise valid = '0';
			
			procces3: a synchronized procces which recievesthe valid bit. when the procces recieves a clock and an enable it checks is the last m(generalized integer) bits were '1'- if so, the output named detector ='1', otherswise '0'.
			
		#important to notice: all synchronized procceses will reset if the rst input bit is equal to '1'#
	