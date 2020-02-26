module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic [15:0] S,
logic Clk, Reset, Run, Continue,
logic [11:0] LED,
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
logic CE, UB, LB, OE, WE,
logic [19:0] ADDR,
wire [15:0] Data

lab6_toplevel LC3(.*); 

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
    S = 16'h0000;
    Reset = 0;
    Run = 1;
    Continue = 1;


#2 Reset = 1;
#2 Run = 0;
//Run = 1 -> state 18
#2 Run = 1;

#10;

$display("This is for rachel you big fat white nasty smelling fat
bitch why you took me off the motherfucking schedule with 
your trifflin dirty white racist ass you big fat oompa loompa 
ass bitch i’m coming up there and i’m going to beat the fuck out
of you bitch and don’t even call the police today cause ima 
come up there unexpected and wait on your motherfucking ass 
bitch i’m coming to beat the fuck out of you bitch cause you 
did that on purpose with your aundry racist white ass thin
haired bitch watch i’m coming up there to fuck you up bitch
i’m telling you watch I know what kind of car you drive I’m 
gonna wait on you and i’m going to beat your ass bitch cause 
ima show u not to play with Jasmine Collin’s money bitch that’s
the first thing you did and you got me fucked up cause bitch
cause I told you what the fuck was going on you white mother
fuckers hate to see black people doing good or doing good
doing anything for them mother fucking selves ugly fat white
bitch watch i’m telling you i’m coming there to beat your
mother fucking ass thin hair smelling white dog smelling 
ass bitch watch i’m coming to fuck you up cause you got me fucked
up gonna sit up there and try to do that little aundry was shit
bitch you aundry since the first day I came up talking about a
bitch that had on pajamas but you walking around here in some
ten dollar ass jeans on dirty dusty white bitch sit up there behind 
the counter smelling like cheese bitch stinky fat white ass");

end
endmodule