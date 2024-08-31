VHD files and brief functional description



AdderSub.vhd:
input: X,Y as an n-bit vector and ALUFN[2:0] as 3-bit vector.
output: S as an n-bit vector and cout as a single bit.
functional:consist of n FA's for each bit. Takes X and Y signals
and perform addition/subtraction depends on ALUFN signal.

FA.vhd: (not a module but an elemnt of AdderSub module)
input: xi,yi and cin as 1-bit.
output: s and cout as 1-bit.
functional: base element of Adder. Adds xi,yi,cin together and gives as the result with carry .

Logic.vhd:
input: X,Y as an n-bit vector and ALUFN[2:0] as 3-bit vector.
output: S as an n-bit vector and cout(optional) as a single bit.
functional: performs a bitwise operation between X and Y. The exact operation is depending on ALUFN.

Shifter:
input: X,Y as an n-bit vector and ALUFN[2:0] as 3-bit vector.
output: S as an n-bit vector and cout as a single bit.
functional: performs a logical shift left/right on Y, X[2:0] times, depends on ALUFN signal.

Top:
input: X_i,Y_i as an n-bit vector and ALUFN_i as 5-bit vector.
output: ALUout_o as an n-bit vector and Nflag_o,Cflag_o,Zflag_o,Vflag_o as a single bits.
functional: Performs a certain operation between X_i and Y_i. The operation performed 
by certain module discribed above and depends on ALUFN_i signal, by its 2 MSB bits.
The rest of ALUFN_i bits (3 LSB) determines the sub-mode of the mudule. The output is the output of whole
system with 4 flag bits, N,C,Z,V.