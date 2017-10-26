// this is a function
{}

// simple SinOsc UGen
{SinOsc.ar}.play;

// removing selectively a Synth from the server
// REMEMBER: the play function returns a Synth that can be freed.
x = {SinOsc.ar}.play;
x.free;

// building a function with arguments
(
z = {
    arg freq=440, amp=0.125;
    var sig;
    sig = SinOsc.ar(freq, mul: amp);
}.play;
)

// modifying argument of a function
(
z.set(\freq, 880);
)



{Pan2.ar(SinOsc.ar(100,MouseX.kr(-8*pi, 8*pi),0.5),0.0)}.play

(
w = Window("soundfiles looper", Rect(10, 700, 750, 100));
w.front;
)

{ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)* 400 + 500, 0.03, 0.003)}!2)+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)* 800 + 1000, 0.03, 0.005)}!2) }.play

{BPF.ar(BrownNoise.ar,SinOsc.kr(LFNoise2.kr(50,50,50),0,100,2000),0.001,10)!2}.play


roxySpace.push(s.boot);

~out.play;
~out.fadeTime = 5;


// krekel A

(
~out = { HPF.ar(
Pulse.ar(LFTri.ar(Rand(3, 10) * [1, 1.01]) * 80 + LFNoise1.kr(1, 40, 130)),
			exprand(7000, 12000)
		) * 0.5
	};
)

~out.play;


// Birds
(
{
	var dry = Mix.arFill(6, { var freq, bird;
		freq = rrand(94.0, 102.0) + Lag.ar(LFSaw.ar(7 + 1.5.rand2, 1.0.rand,
rrand(11.0,15.0)), 0.1);
		bird = SinOsc.ar(freq.midicps, 1.0.rand,
LFPulse.kr(1/rrand(12.0,15.6), 1.0.rand, 0.16, 0.05));
		Rotate2.ar(bird, Silent.ar(1), 1.0.rand2);
	});
	var z = dry;
	12.do { z = AllpassL.ar(z, 0.07, 0.06.rand, rrand(0.7, 2.0)) };
	dry * 0.7 + (z * 0.3)
}.play;
)

(
{
	var dry = Mix.arFill(50, { var freq, bird, time;
		time = rrand(12.0,15.6);
		if(0.5.coin, {
			freq = rrand(94.0, 102.0) + Lag.ar(LFSaw.ar(7 + 7.rand2, 1.0.rand,
rrand(11.0,15.0)), 0.1);
		},{
			freq = rrand(94.0, 102.0) + Lag.ar(SinOsc.ar(7 + 7.rand2, 1.0.rand,
rrand(11.0,15.0)), 0.1);
		});
		bird = SinOsc.ar(freq.midicps, 1.0.rand,
LFPulse.kr(1/time, 1.0.rand, 0.16, 0.05));
		Rotate2.ar(bird, Silent.ar(1), 1.0.rand2);
	});
	var z = dry;
	12.do { z = AllpassL.ar(z, 0.05, 0.04.rand, rrand(0.7, 2.0)) };
	dry * 0.7 + (z * 0.2)
}.play;
)


(
{
BPF.ar(WhiteNoise.ar(1.5), XLine.ar(7000, 100, [0.42, 0.56]), 0.75, XLine.ar(1, 0.09, 2)) +

Pan2.ar(BPF.ar(
	Pulse.ar(LFNoise1.kr(0.5).range(3.2, 13), 0.5),
	LFNoise1.kr(0.123).range(606, 1800),
	0.23,
	LFPulse.kr(LFNoise1.kr(0.1).range(0, 0.23), 0.56).abs;
	),
LFNoise1.kr(0.23)) +

Pan2.ar(SinOsc.ar(77, SinOsc.ar(52, 0, SinOsc.ar(0.25, 0, 2pi))), SinOsc.ar(0.125), XLine.kr(0.0001, 0.125, 120));

}.play;
)


(
~out = { HPF.ar( Pulse.ar(LFTri.ar(Rand(0.02, 0.2) * [1, 1.01]) * 10
	+ LFNoise1.kr(1, 20,80)), exprand(1000, 1200) ) * 0.25 };
)

~out.play;
~out.fadeTime = 5;

300.do{{Pan2.ar(SinOsc.ar(rrand(2000, 3000)+LFNoise2.kr(rrand(0.05,0.1), 50, 50), 2.0.rand, 0.005*SinOsc.kr(rrand(1.0, 10.0), 0, 0.5, 0.5)), LFNoise2.kr(rrand(0.05,0.1)))}.play};
