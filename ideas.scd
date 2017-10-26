// HARP
{Pluck.ar(
    in: WhiteNoise.ar(0.1),
    trig: Impulse.kr(2),
    maxdelaytime: MouseY.kr(220, 880).reciprocal,
    delaytime: MouseY.kr(220, 880).reciprocal,
    decaytime: 10,
    coef:MouseX.kr(-0.1, 0.5)) !2 }.play(s)


// Harp2
(
{
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
 burst = WhiteNoise.ar(burstEnv);
 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)

//Harp3
(
{
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
 burst = PinkNoise.ar(burstEnv);
 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)

// Waves
a = { | dustrate = 100, numerator = 0.5, poleparam = 0.7 |
x = OnePole.ar(WhiteNoise.ar(0.1)+Dust.ar(dustrate, 0.5), poleparam);
x = x + Splay.ar(FreqShift.ar(x, numerator / (4..7)));
}.play;

// Waves2
({ Decay2.ar(
	SinOsc.ar([0.11,0.2345],0,0.1),
	0.01,
	0.03,
	PinkNoise.ar(10,mul:0.08))
}.play;)

// Bubbles
(
{
({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
		* 400 + 500, 0.03, 0.003)}!2)
	+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
	* 800 + 1000, 0.03, 0.005)}!2)
	* 4
}.play
)

// Wind



// Instrument
(
{
	var son, son2;
	son = Klank.ar(`[     // Klank: A bank of fixed requency resonators
		[151,  250, 334],  // freqs
		[0.9, 0.6, 0.15],// amps
		[6.0, 2.6, 1.4]   // ring times
		]
	, Impulse.ar(1));
	son2 = CombL.ar(son, 0.2, 0.2, 0.2, 1, 0);
	Out.ar(0, Pan2.ar(son * 0.2));
}.play;
)