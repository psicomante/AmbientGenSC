/**
 *
 * White Noise Ambient
 *
 * narirou
 * 2013/07/22
 *
 * Public licenced.
 *
 */


(

// ------------------
//
//     SynthDef
//
// ------------------

// Swish
SynthDef(\swish,{
	var basePitch, swishPitch, swish, noise;
	var sound;
	var env;

	noise = WhiteNoise.ar(0.5);

	basePitch =	EnvGen.kr(
		Env(
			[0.80, 0.80, 0.44, 0.36, 0.24, 0.12, 0.00],
			[1.00, 0.00, 0.00, 0.20, 0.18, 0.18],
			2.0
		)
	);

	swishPitch = LFNoise2.kr(500, 0, 1) * basePitch.range(2.0, 2.7);

	swish = Mix.fill(
		4,
		{|i|
			BPF.ar(noise, swishPitch + SinOsc.kr(i * basePitch.range(10, 0.01)) * 1200);
		}
	);

	sound = Pan2.ar(
		swish,
		Line.kr(-0.95, 0.95, 4.5),
		0.04
	);

	env = EnvGen.ar(
		Env.linen(1.0, 0.5, 4.5, 0.8, \welch),
		doneAction:2
	);

	Out.ar([0,1], sound * env);
}).store;


// Swish2
SynthDef(\swish2,{
	var sound;
	var env;

	sound = Resonz.ar(
		WhiteNoise.ar(0.5),
		1000,
		XLine.kr(0.001, 0.8, 5.3)
	);

	env = EnvGen.ar(
		Env.linen(0.5, 0.5, 6.0, 1, \welch),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Swish3
SynthDef(\swish3,{
	var noise, basePitch, swishPitch, swish;
	var sound;
	var env;

	noise = Limiter.ar(
		GVerb.ar(
			BPF.ar(
				WhiteNoise.ar([0.05, 0.05]),
				SinOsc.kr(
					SinOsc.kr([1/108, 1/109]).range(1/108, 1/13)
				).exprange(200, 1300),
				PMOsc.kr(1/20, 1/256, 3).range(0.1, 3)
			),
			roomsize: 10,
			damping: PMOsc.kr(1/27, 1/108, 3).range(0.5, 1),
			drylevel: SinOsc.kr(1/9).range(0.1, 1)
		)
	);

	basePitch =	EnvGen.kr(
		Env(
			[0.80, 0.80, 0.44, 0.36, 0.24, 0.12, 0.00],
			[1.00, 0.00, 0.00, 0.20, 0.18, 0.18],
			2.0
		)
	);

	swishPitch = LFNoise2.kr(500, 0, 1) * basePitch.range(2.0, 2.7);

	swish = Mix.fill(
		3,
		{|i|
			BPF.ar(noise, swishPitch + SinOsc.kr(i * basePitch.range(9, 0.1)) * 1000);
		}
	);

	sound = Pan2.ar(
		swish,
		Line.kr(-0.95, 0.95, 1.0),
		1.0
	);

	env = EnvGen.ar(
		Env.linen(2, 0.5, 6.5, 0.5, \welch),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Swish4
SynthDef(\swish4,{
	var sound;
	var env;

	sound = Resonz.ar(
		WhiteNoise.ar(0.5),
		1800,
		XLine.kr(0.001, 0.8, 5.3)
	);

	env = EnvGen.ar(
		Env.linen(0.5, 0.5, 6.0, 1, \welch),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Step
SynthDef(\step, { arg freq = 0, degree;
	var sound;
	var env;

	sound = OnePole.ar(
		BPF.ar(WhiteNoise.ar(1), 1800),
		0.5
	) * 0.1;

	sound = FreeVerb.ar(sound, 0.5, 0.5, 0.1);

	env = EnvGen.ar(
		Env.perc(0.1, 0.2, 0.5),
		doneAction: 2
	);

	Out.ar([0, 1], sound * env);
}).store;


// Step3
SynthDef(\step3, {
	var freq, vib, r;
	var sound;
	var env;

	freq = LFCub.kr(LFCub.kr(0.2, 0, 8, 10));

	vib = BPF.kr(PinkNoise.kr, freq, 0.3) * 10;

	r = TRand.kr(
		100, 100,
		LFSaw.kr(vib, 0, 2, 30)
	);

	sound = BPF.ar( WhiteNoise.ar(1), r/3 );

	sound = Decay.ar(
		Impulse.ar(XLine.kr(10, 20, 4)),
		0.2,
		sound
	);

	sound = OnePole.ar(
		sound,
		FSinOsc.kr(Line.kr(0.1, 5, 10))
	);

	sound = Pan2.ar(
		sound,
		FSinOsc.kr(3),
		1.0
	);

	env = EnvGen.ar(
		Env.linen(0.8, 0.5, 4.0, 1, \welch),
		doneAction: 2
	);

	Out.ar([0, 1], sound * env);
}).store;


// Blow
SynthDef(\blow, {
	var sound;
	var env;

	sound = OnePole.ar(
		BPF.ar(WhiteNoise.ar(1), 100),
		FSinOsc.kr(Line.kr(0.1, 5, 10))
	);

	sound = sound + Splay.ar(FreqShift.ar(sound, 1/(4..7)));

	sound = Pan2.ar(
		sound,
		FSinOsc.kr(1),
		0.1
	);

	env = EnvGen.ar(
		Env.linen(0.5, 0, 3.8, 1, \welch),
		doneAction: 2
	);

	Out.ar([0, 1], sound * env);
}).store;


// Wind
SynthDef(\wind, {
	var pitch;
	var sound;
	var env;

	sound = HPF.ar(WhiteNoise.ar(0.5), XLine.kr(800, 1800, 3)) * 0.05;

	3.do {|i|
		var filtered = RLPF.ar(WhiteNoise.ar(0.5), 1000, 0.1) * 0.1;
		sound = DelayN.ar(filtered, 1, 0.1*i, 0, sound * 0.7);
	};

	env = EnvGen.ar(
		Env.linen(0.2, 0, 2.8, 0.8, \welch),
		doneAction:2
	);

	Out.ar([0,1], sound * env);
}).store;


// Sinbal
SynthDef(\sinbal, {	arg amp = 1, octave=8.0;
	var noise, tempo;
	var sound;
	var env;

	noise = HPF.ar(WhiteNoise.ar(0.2), 1000);

	tempo = SinOsc.kr(0, 1, 0, 3800);

	sound = RHPF.ar(noise, tempo, 1000) * 0.1;

	env = EnvGen.ar(
		Env.perc,
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Sinbal Long
SynthDef(\sinbalLong, {
	var pitch;
	var sound;
	var env;

	sound = HPF.ar(WhiteNoise.ar(0.5), XLine.kr(1000, 2000, 1)) * 0.05;

	3.do {|i|
		var filtered = RLPF.ar(WhiteNoise.ar(0.5), 1000, 0.1) * 0.1;
		sound = DelayN.ar(filtered, 1, 0.1*i, 0, sound * 0.6);
	};

	sound = Decay.ar(
		Impulse.ar(13, 0.25),
		0.5,
		sound,
		sound
	);

	sound = Pan2.ar(
		sound,
		Line.kr(-0.95, 0.95, 9.0)
	);

	env = EnvGen.ar(
		Env.linen(1.0, 0, 8.0, 0.8, \welch),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Sinbal Step
SynthDef(\sinbalStep, {
	var sound;
	var env;

	sound = HPF.ar(WhiteNoise.ar(0.5), XLine.kr(1000, 2000, 0.3)) * 0.05;

	3.do {|i|
		var filtered = RLPF.ar(WhiteNoise.ar(0.5), 1000, 0.1) * 0.1;
		sound = DelayN.ar(filtered, 1, 0.1*i, 0, sound * 0.6);
	};

	sound = Decay.ar(
		Impulse.ar(4.7, 0.25),
		0.5,
		sound,
		sound
	);

	env = EnvGen.ar(
		Env.linen(0.2, 0, 6.8, 0.8, \welch),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Sinbal One
SynthDef(\sinbalOne, {
	var sound;
	var env;

	sound = HPF.ar(WhiteNoise.ar(0.5), XLine.kr(1000, 2000, 3)) * 0.05;

	3.do {|i|
		var filtered = RLPF.ar(WhiteNoise.ar(0.5), 1000, 0.1) * 0.1;
		sound = DelayN.ar(filtered, 1, 0.1*i, 0, sound * 0.6);
	};

	env = EnvGen.ar(
		Env.perc(0.05, 0.8, 1, -4),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;



// Sizuku
SynthDef(\sizuku, { arg freq = 1000;
	var sound;
	var env;

	sound = RLPF.ar(WhiteNoise.ar(0.5), freq, 0.1) * 0.1;

	2.do{|i|
		sound = DelayN.ar(sound, 1, 0.1*i, 0, sound * 0.5);
	};

	env = EnvGen.ar(
		Env.perc(0.05, 1, 1, -5),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Sizuku Random
SynthDef(\sizukuRandom, { arg freq = 1000;
	var sound;
	var env;

	sound = RLPF.ar(WhiteNoise.ar(0.5), Rand(300, freq), 0.1) * 0.1;

	2.do{|i|
		sound = DelayN.ar(sound, 1, 0.1*i, 0, sound * 0.5);
	};

	env = EnvGen.ar(
		Env.perc(0.05, 1, 1, -5),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;


// Sizuku Echo
SynthDef(\sizukuEcho, { arg freq = 1000;
	var sound;
	var env;

	sound = RLPF.ar(WhiteNoise.ar(0.5), Rand(2000, freq), 0.1) * 0.1;

	2.do {|i|
		sound = DelayN.ar(sound, 1, 0.1 * i, 0, sound * 0.5);
	};

	sound = Decay.ar(
		Impulse.ar(XLine.kr(2,20,2.0), 0.25),
		0.5,
		sound,
		sound
	);

	env = EnvGen.ar(
		Env.perc(0.05, 3, 1, -5),
		doneAction:2
	);

	Out.ar([0,1], sound * env);
}).store;


// Background Wind
SynthDef(\bg,{
	var lfs, lfn, lfs2, lfn2, dust, sin, sin2;
	var noise, noise2;
	var sound;
	var env;

	// 1
	lfs = LFSaw.ar([1, 5], 0, 3, 70);

	lfn = LFNoise2.ar(1, 10, lfs).midicps;

	// 2
	lfs2 = LFSaw.ar(1, 0, 2, 40);

	lfn2 = LFNoise0.ar(5, 20, lfs2).midicps + 100;


	dust = Dust.kr( 5, lfn );

	sin = HPF.ar(
		SinOsc.ar(lfn, 0, 0.4),
		1500,
	);
	sin2 = HPF.ar(
		SinOsc.ar(TRand.kr(300, 1000, dust)),
		500
	) * 0.3;

	noise = BPF.ar(WhiteNoise.ar(0.5), lfn, 0.4);
	noise = CombN.ar(noise, 1, 0.3, 2);

	noise2 = BPF.ar(WhiteNoise.ar(0.5), lfn2, 0.4);
	noise2 = CombN.ar(noise2, 1, 0.3, 2);

	sound = Mix.ar([noise2, noise]) * 0.5;
	sound = Pan2.ar(sound, FSinOsc.kr(0.5)*Rand(-1, 1), 0.05);

	env = EnvGen.ar(
		Env.adsr(0.4, 0.3, 3.0, 3.0, 1),
		EnvGen.kr(Env.linen(0.1, 1.5, 0.1)),
		doneAction: 2
	);

	Out.ar([0,1], sound * env);
}).store;



// ------------------
//
//      Pbinds
//
// ------------------

// Swish
~swish = Pbind(
	\instrument, \swish,
	\degree, Pseq([1], 1),
	\dur, 6.5
);

~swish2 = Pbind(
	\instrument, \swish2,
	\degree, Pseq([1], 1),
	\dur, 6.5
);

~swish3 = Pbind(
	\instrument, \swish3,
	\degree, Pseq([1], 1),
	\dur, 16.0
);

~swish4 = Pbind(
	\instrument, \swish4,
	\degree, Pseq([1], 1),
	\dur, 9.0
);


// Step
~step = Pbind(
	\instrument, \step,
	\degree, Pseq(Array.new.extend(50,1), 1),
	\dur, Pseq(List[0.6, 0.2, 0.2, 0.6, 0.2, 0.6], inf),
	\octave, Pfunc(8.0),
	\scale, Scale.major
);

~step3 = Pbind(
	\instrument, \step3,
	\degree, Pseq([1], 1),
	\dur, 6.5
);


// Blow
~blow = Pbind(
	\instrument, \blow,
	\degree, Pseq([1], 11),
	\dur, 6.5
);


// Sizuku
~sizuku = Pbind(
	\instrument, \sizuku,
	\degree, Pseq([1], 100),
	\dur, 2.5,
	\octave, 6.0,
	\scale, Scale.major
);

~sizuku2 = Pbind(
	\instrument, \sizuku,
	\degree, Pseq([3, 4, 6, 7], 100),
	\dur, 1.0,
	\octave, 6.0,
	\scale, Scale.major
);

~sizuku3 = Pbind(
	\instrument, \sizukuRandom,
	\degree, Pseq([1, 3, 8], 1),
	\dur, Pseq(List[1.0, 0.1, 1.2, 0.2, 0.8, 0.1], inf),
	\octave, 6.0,
	\scale, Scale.major
);

~sizukuEcho = Pbind(
	\instrument, \sizukuEcho,
	\degree, Pseq([3, 6], 6 * 2 - 3),// (17.8 * 2) * 2 + 8.0 + 5.2
	\dur, Pseq(List[5.0, 0.2, 7.0, 1.0, 4.0, 0.6], inf), // 17.8
	\octave, 6.0,
	\scale, Scale.major
);


// Wind
~wind = Pbind(
	\instrument, \wind,
	\degree, Pseq([1], 1),
	\dur, 4.5
);


// Sinbal
~sinbal = Pbind(
	\instrument, \sinbal,
	\amp, 1,
	\degree, Pseq(Array.new.extend(60,1), 1),
	\dur, Pseq(List[0.6, 0.2, 0.2, 0.6, 0.2, 0.6], inf),
	\octave, Pfunc(8.0),
	\scale, Scale.major
);

~sinbalLong = Pbind(
	\instrument, \sinbalLong,
	\degree, Pseq([1], 1),
	\dur, 9.0
);

~sinbalStep = Pbind(
	\instrument, \sinbalStep,
	\degree, Pseq([1], 1),
	\dur, 9.0
);

~sinbalOne = Pbind(
	\instrument, \sinbalOne,
	\degree, Pseq([1], 100),
	\dur, Pseq(List[0.5, 1.5], inf)
);


// Background Wind
~bg = Pbind(
	\instrument, \bg,
	\degree, Pseq([1], 12),
	\dur, 5.0
);


// ------------------
//
//      Start
//
// ------------------

Ptpar([

	// Preset01
	00.0, ~swish2,
	04.5, ~swish,
	05.5, ~sinbalLong,
	07.0, ~wind,

	11.0, ~swish,
	12.0, ~sinbalLong,
	13.5, ~wind,

	// Preset02
	16.5, ~swish4,
	18.0, ~swish3,
	19.0, ~sinbalStep,
	20.5, ~sinbalLong,
	21.5, ~wind,

	25.5, ~swish,
	26.5, ~sinbalLong,
	28.0, ~wind,

	31.0, ~swish,
	32.5, ~sinbalLong,
	34.0, ~wind,

	// Preset01
	37.0, ~swish2,
	41.5, ~swish,
	42.5, ~sinbalLong,
	44.0, ~wind,

	47.0, ~swish,
	48.0, ~sinbalLong,
	49.5, ~wind,

	// Preset02
	52.5, ~swish4,
	54.0, ~swish3,
	55.0, ~sinbalStep,
	56.5, ~sinbalLong,
	58.0, ~wind,

	61.0, ~swish,
	62.0, ~sinbalLong,
	63.5, ~wind,

	66.5, ~swish,
	67.5, ~sinbalLong,
	69.0, ~wind,

	// End
	73.5, ~sinbalLong,
	// 75.0, ~wind,

	// test
	// 00.0, ~sizuku,
	// 01.8, ~sizuku2,
	// 01.8, ~sizuku3,
	// 06.0, ~sinbal,
	// 01.0, ~step,
	// 05.5, ~sinbalStep,
	// 05.5, ~sinbalOne,

	// Preset3
	09.0, ~sizukuEcho,

	// Preset4
	02.0, ~bg,
	04.2, ~blow,

], 1).play;

)
