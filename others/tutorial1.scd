/***************/
/** LESSON 1 **/
/***************/
(
var number;
number = 3.cubed;
)

// global variable
~number = 3.cubed;

// can be evaluated in different times, first evaluate previous line
// then the following one. it gives no error
~number;

// var with one letter are always global??
r = 4.cubed;
r;

// instead, if you evalueated the 5 without the 4, it gives error

/***************/
/** LESSON 2 **/
/***************/
Server.local.boot;
Server.local.quit;

s.quit;
s.boot;

// simple fun
{SinOsc.ar}.play;

// Synth individual entities resides on server, can be destroyed with free.
x = {SinOsc.ar}.play;
x.free;

// create a function without play immediately
y = {SinOsc.ar};
x = y.play; // assigning synth to variable x
x.free; // free the synth

// Look up doc
// Shift+Cmd+D

// UGEN
// ar audio rate outputs values at samples rate (44.100 per s) - calculates values continuously
// kr control rate outputs values - calculates values once

// DOC
// evaluate string sith Shift+Enter in Documentation

x = {SinOsc.ar(700, 0, 0.125, 0)}.play;
x.free;

x = {SinOsc.ar(700, mul: 0.125)}.play;

x = {SinOsc.ar(700) * 0.125}.play;

(
z = {
    arg freq = 440, amp = 1;
    var sig;
    sig = SinOsc.ar(freq) * amp;
}.play
)

z.set(\freq, 330);
z.set(\amp, 0.125);
z.set(\freq, 120, \amp, 0.1);

// more complicate example with LFNoise0 (random values at a rate)
(
z = {
    arg vibfreq = 8;
    var freq, sig;
    freq = LFNoise0.kr(vibfreq, 400, 600); // -400 + 600 < x < 400 + 600
    sig = SinOsc.ar(freq);
}.play;
)

z.set(\vibfreq, 400);
z.set(\vibfreq, 100);
z.free;

// same as above but with range
(
z = {
    var freq, sig;
    freq = LFNoise0.kr(8).range(200,1000);
    sig = SinOsc.ar(freq);
}.play;
)

z.free;

// using exponential range (because of octaves!)
(
z = {
    var freq, sig;
    freq = LFNoise0.kr(8).exprange(200,1000);
    sig = SinOsc.ar(freq);
}.play;
)

z.free;

// changing amp in time
(
z = {
    arg noiseHz = 8;
    var freq, amp, sig;
    freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
    amp = LFNoise1.kr(12).exprange(0.02, 1);
    sig = SinOsc.ar(freq, mul: amp);
}.play;
)

// rand
z.set(\noiseHz, exprand(4,64));

// Pan2
{Pan2.ar(SinOsc.ar(440,0,0.1),0.0)}.play
{Pan2.ar(SinOsc.ar(MouseX.kr(440,880),0,0.1),0.0)}.play

(
z = {
	var n = 60; 	//try changing me to 34, or 3, and then re-running...

	Resonz.ar(
		Mix.fill(n, {

			var freq=rrand(50,560.3);
			var numcps= rrand(2,20);

			Pan2.ar(Gendy1.ar(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq, 1.0.rand, 1.0.rand, numcps, SinOsc.kr(exprand(0.02,0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)), 1.0.rand2)
		}),
		MouseX.kr(100,2000),
		MouseY.kr(0.01,1.0)
	);
}.play
)

z.set(\n, rrand(3,34));

// PulseTest
LFSaw

// Frequency Analyzer
FreqScope.new

{SinOsc.ar(150, mul:0.123)}.play;