({
 RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([1, 2]).range(100, 3000), 0.02)
}.play;)

{ FSinOsc.ar(FSinOsc.kr(FSinOsc.kr(0.2,0,8,10),0, 400,800),0,0.1) }.scope(1, zoom: 4);

x = WhiteNoise.ar(MouseX.kr(1,2), 0.5);"/Users/rob/Code/Universita/edam/EDAM-project/project.scd"

// Complete with kick and snare
// by Thor Magnusson, based on patch by Dan Stowell from the sc-users list
(
{
	var trig, note, son, sweep, bassenv, bd, sd, swr;

   trig = Impulse.kr(1);

	note = Demand.kr(trig, 0, Dxrand([70,28,28,28,28,28,27,25].midicps, inf));

	swr = Demand.kr(trig, 0, Drand([0.5, 1, 2, 3, 4, 6], inf));
	sweep = LFTri.ar(swr).exprange(40, 3000);

	son = LFSaw.ar(note * [0.99, 1, 1.01]).sum;
	son = LPF.ar(son, sweep);
	son = Normalizer.ar(son);
	son = son + BPF.ar(son, 1500, 2);

	//////// special flavours:
	// hi manster
	son = Select.ar(TRand.kr(trig: trig) < 0.4, [son, HPF.ar(son, 2000) * 4]);
	// sweep manster
	son = Select.ar(TRand.kr(trig: trig) < 0.5, [son, HPF.ar(son, sweep*0.5) * 4]);
	// decimate
	son = Select.ar(TRand.kr(trig: trig) < 0.2, [son, son.round(0.2)]);

   son = son + GVerb.ar(son, 9, 0.1, 0.7, mul: 0.1);
	son = (son * 2).clip2;

   son = RLPF.ar(son + SinOsc.ar(note,0,LFTri.ar(swr,mul:2,add:1)).tanh, note*4, 0.4);

   bassenv = Decay.ar(T2A.ar(Demand.kr(Impulse.kr(4),0,Dseq([1,0,0,1,0,0,0,0],inf))),0.7);
   bd = FreeVerb.ar(SinOsc.ar(40+(bassenv**3*200),0,7*bassenv).clip2);
   sd = LPF.ar(4*PinkNoise.ar*Decay.ar(Impulse.ar(0.5,0.5),0.4), 3000);
   sd = (sd + BPF.ar(4*sd,1200)).clip2;

   FreeVerb.ar(((son*0.5)+bd+sd).tanh, 0.3, 0.65);
}.play
)


x = Synth(\wobblebass, [\wob, 0]); // no wobble
x.set(\wob, 3); // give it some wob

({
    x = Crackle.ar(MouseY.kr(1,2), 0.5);
    LPF.ar(x, MouseX.kr(1, 1e5, 1), 0.2)
}.scope(1);
)

(Pbind(\degree, 0, \dur, 0.5).play;
Pbind(\degree, -8, \dur, 0.5).play;)

Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 999), \dur, 0.2).play;


x = {Array.fill(36, {rand(-8,8).round}); };
z = { Array.fill(36, {rand(0.1, 0.5)}); };
z.value;
Pbind(\degree, Pseq(x.value, inf), \dur, Pseq(z.value, inf)).play;

(
Pbind(
\degree, Pseq([0, −1, 2, −3, 4, −3, 7, 11, 4, 2, 0, −3], 5),
\dur, Pseq([0.2, 0.1, 0.1], inf),
\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
\legato, 0.4,
\bps, 40
).play;
)

(
Pbind(
\degree, Prand([2, 3, 4, 5, 6], inf),
\dur, 0.5,
\amp, 0.2,
\legato, 0.5
).play;
)

(
Pbind(
\freq, Pwhite(100, 500),
\dur, Prand([0.15, 0.25, 0.3], inf),
\amp, Prand([0.1, 0.5, 0.23, 0.25], inf),
\legato, Pwhite(0.2,0.5)
).trace.play;
)

{ Resonz.ar(WhiteNoise.ar(0.5), 2000, XLine.kr(0.001, 1, 8)) }.scope(1);
{ Dust.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);
{ Blip.ar(200,Line.kr(1,100,20),0.2) }.scope(1);
{ RLPF.ar(Pulse.ar([100,250],0.5,0.1), XLine.kr(8000,400,5), 0.05) }.scope(1);

SynthDescLib.global.at(\SinOsc).makeWindow;

play {
  SinOsc.ar(2500) * 0.2 * LFPulse.ar(5)
}

play {
  WhiteNoise.ar(LFNoise2.kr(1).poll)
}

play {
  SinOsc.ar(LFNoise0.kr(170).linlin(-1, 1, 800, 2400)) * 0.3
}

play {
  val noise = Mix.fill(12)(WhiteNoise.ar)
  val gaus  = LPF.ar(BPF.ar(noise, 50, 1/0.4), 500)

  //
  val sin  = SinOsc.ar(gaus.linlin(-1, 1, 40, 80)) * gaus.squared * 10
  val clip = (sin - 0.35).max(0)

  val osc = Mix.fold(clip, 2)(HPF.ar(_, 500))

  Seq(osc, osc)
}

{
x = OnePole.ar(WhiteNoise.ar(0.1)+Dust.ar(100, 0.5), 0.7);
x = x + Splay.ar(FreqShift.ar(x, 1/(4..7)));
}.play

{
({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2)
* 4
}.play