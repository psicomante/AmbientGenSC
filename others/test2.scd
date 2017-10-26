({
	PinkNoise.ar(
	mul: SinOsc.kr(0.125).range(0, 0.25))
}.play;)

(SynthDef(\swish,{
	var basePitch, swishPitch, swish, noise;
	var sound;
	var env;

	noise = PinkNoise.ar(0.5);

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
}).store;)

(SynthDef(\swish2,{
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
}).store;)

(SynthDef(\swish3,{
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
}).store;)

(SynthDef(\swish4,{
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
}).store;)

x = Synth(\swish4);


(SynthDef(\waves,{
    arg offset_freq=4.5;
    var waves,wind,output;

  waves=Mix.fill(2,{
    arg index;
    var lf, rf , mod_amp, env;
    lf= (index+1)*120; // tone pure carrier
    rf= lf + offset_freq;
    mod_amp=0.1*(1/(index+1)**2); // quadratic decrease of amp
    SinOsc.ar([lf,rf],0,mod_amp);
    });

  //wind=Pan2.ar(In.ar(~global[\bus][\wind].index,1) // collect wind from private wind bus
     //,SinOsc.kr(0.125,0,0.8,0));
  output=waves;
  Out.ar(0,output);
}).add;)

x = Synth(\waves);


(SynthDef(\waternoise,{

   var noise;

   noise=Mix.fill(3,{
   arg index;
   var freq;
    freq =100+1000*index+ Rand(0,0.125);
    SinOsc.ar(freq,0,0.005/(100*index+1)**2);
});

  noise=noise + WhiteNoise.ar(0.005); // add white noise to simulate particicles of water wapour
  noise=BLowPass.ar(noise,2000,1.5);
  noise=GVerb.ar(noise,250,2.5,0.7,0.4,15,0.4); // add reverb of outdoor scenario
  Out.ar(0,noise*20);
}).add;)

y = Synth(\waternoise);

(SynthDef(\chan, {
    arg out = 0, freq = 200, kFreq = 5;

    var n = 8;
    var mix = Mix.fill(n, {|i| LFPulse.ar(i+kFreq)*SinOsc.ar(i + 1*freq)});

    Out.ar(0, mix/n);
}).add;)

z = Synth(\chan).plot(1);

(
{
    var in, chain;
    in = WhiteNoise.ar(0.2);
    chain = FFT(LocalBuf(2048), in);
    chain = PV_BinShift(chain, SinOsc.kr(0.1));
    IFFT(chain);
}.freqscope
)

(SynthDef(\vocali, {
    arg f1, f2, fund = 70, amp = 0.05;
    var source = Saw.ar(fund);
    var vowel1 = Normalizer.ar(BPF.ar(source, f1, 0.1));
    var vowel2 = Normalizer.ar(BPF.ar(source, f2, 0.1));
    var vowel = (vowel1 + vowel2)*amp;

    Out.ar(0, vowel.dup)

}).add;)

x = Synth(\vocali, [\f1, 1620, \f2, 780]);


(// Swish
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
		Env.linen(1.0, 0.5, 4.5, 0.8, \welch).test.plot,
		doneAction:2
	);


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

	Out.ar([0,1], sound * env);
}).add;)

~swish = Pbind(
	\instrument, \swish,
	\degree, Pseq([1], 1),
	\dur, 6.5
);

Ptpar([

	// Preset01
	00.0, ~swish,
	04.5, ~swish,

], 1).play;

SynthDef(\crackle, { arg inChan=0, lpfreq=1000, hpfreq=2000,  sustain=2, amp=0.1;
	var	sig, sig1, sig2, lpf, popHz, lagtime, noise, popHzMul,
		pan1, pan2, panmod1, panmod2, env, ampIn;
	ampIn = Amplitude.kr(SoundIn.ar(inChan), 0.01, 0.1).range(0,1);
	env = EnvGen.kr(Env.linen(sustainTime:sustain, level:1+ampIn), doneAction:2);
	popHzMul = Decay.kr(Dust.kr(0.15), 3, 10, 0.8);
	popHz = 	LFNoise1.kr(20).exprange(0.1,10) * popHzMul;
	sig = Dust2.ar(popHz);
	lpf = LFNoise1.kr(10).exprange(lpfreq,20000);
	lagtime = LFNoise1.kr(20).range(0.008,0.0001);
	sig = LPF.ar(sig, lpf);
	sig = Lag.ar(sig, lagtime);
	sig = sig + FreeVerb.ar(sig, 0.8, 1, mul:0.11);
	panmod1 = LFNoise1.kr(5).range(0.2,0.7);
	panmod2 = LFNoise1.kr(5).range(0.2,0.7);
	pan1 = SinOsc.kr(panmod1).range(-0.2,0.2);
	pan2 = SinOsc.kr(panmod2).range(-0.2,0.2);
	sig1 = Pan2.ar(sig, pan1, 0.5);
	sig2 = Pan2.ar(sig, pan2, 0.5);
	sig = sig1 + sig2;
	sig = sig + BPF.ar(BrownNoise.ar([0.0025,0.0025]), 7200, 0.4);
	sig = sig + HPF.ar(Crackle.ar([1.999,1.999], 0.0025),hpfreq);
	Out.ar(0, Limiter.ar(sig*12) *env*amp);
}).add;

SynthDef(\bubbleAna, { |out, freq=400, sustain=2, rise=2, amp=0.5|
	var son, env, gliss, root;
	root = freq.cpsmidi;
	gliss = LFSaw.kr(sustain.reciprocal, 0, rise*12, LFSaw.kr([8, 7.23],0, rise, root) ).midicps; // glissando function
	son = SinOsc.ar(gliss, mul:amp); // using sine wave
	son = CombN.ar(son, 0.2, 0.2, 1); // add an echo
	env = EnvGen.kr(Env.linen, timeScale:sustain, doneAction:2);
	Out.ar(out, son * env * amp);
}).add;

(
// sccode by sadguitarius, rewritten and modded
Ndef(\ocean, { |amp=1|
	var src, freqs;
	freqs = 1/[ 8, 10, 12, 14 ];
	src = WhiteNoise.ar(0.1)+Dust.ar(100, 0.5) * Line.kr(0,1,5);
	src = OnePole.ar(src, 0.7, LFTri.ar(LFNoise1.kr(0.5).exprange(0.01,1)).exprange(0.5,1));
	src = src + Splay.ar(FreqShift.ar(src, freqs));
	src * amp
}).play
)

x = Synth(\bubbleAna);


