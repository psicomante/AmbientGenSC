// giocare con sc
z = [1,2,3,4];
z;
z.reverse;
z;
z.mirror;
z;
z.reverse.mirror.mirror;
z.postln.reverse.postln.mirror.postln.mirror.postln;

z = [4,3,2,1];
z.postln.reverse.postln.mirror.postln.mirror;
z.postln.reverse.postln.mirror.postln.mirror.postln;

5.class;
Integer.superclasses;

z.plot("test", Rect(200, 140, 705, 410), false, 2);

// env
(
var v, d, e1, e2, e3, e4;

v = [0, 1, 0.3, 0.8, 0];
d = [2, 3, 1, 4];

e1 = Env.new(v, d, 'linear');
e2 = Env.new(v, d, 'step');

e1.plot;
e2.plot;

e3 = Env.new(v, d, 'exponential');
e4 = Env.new(v, d, [\linear, \step, \exponential, \sine]);

e3.plot;
e4.plot;

[e1, e2, e3, e4].collect{|i| i.asSignal}.flop.flat.plot(numChannels: 4);
)

(
var sig, freq = 440, size = 1000;
var envT, envP;

sig = Signal.newClear(size);
sig.waveFill({arg x, i; sin(x)}, 0, 2pi*50);
envT = Env.triangle(1,1).asSignal(size);

[sig, envT, sig*envT].flop.flat.plot(numChannels: 3);
)

(
SynthDef.new(\pulseSine, {
    arg out = 0, amp = 0.25, kfreq = 5;

    var sinSig;

    sinSig = SinOsc.ar (
        freq: kfreq*50,
        mul: LFPulse.kr(
            freq: kfreq,
            width: 0.25
        )
    );

    Out.ar(bus:out, channelsArray: [sinSig*amp, sinSig*amp]);
}).add;

x = Synth(\pulseSine);

)

({SinOsc.ar (
        freq: 5*50,
        mul: LFPulse.kr(
            freq: 5,
            width: 0.25
        )
)*0.25;}.plot(2);)

({LFPulse.ar(2000, width:0.5, mul:0.25)}).play;

// ENVELOPES

// moltiplicazione esplicita
{ EnvGen.kr(Env.perc, 1.0, doneAction: 0) * SinOsc.ar(mul: 0.5)}.play;

{ EnvGen.kr(Env.perc, 1, timeScale: 10, doneAction: 0) * SinOsc.ar(mul: 0.5)}.play;

{ EnvGen.kr(Env.perc, 0, doneAction: 0) * SinOsc.ar(mul: 0.5)}.play;

{ EnvGen.kr(Env.perc, MouseX.kr(-1, 1), doneAction: 0) * SinOsc.ar(mul: 0.5)}.play;

(SynthDef.new(\sinPerc, {
    Out.ar(0,
        EnvGen.kr(Env.perc, 1, doneAction: 2)
        *
        SinOsc.ar(mul: 0.5)
    );
}).add;)

Synth.new(\sinPerc);

(
w = Window("miniHard", Rect(100, 100, 12*50, 50)).front;
12.do{ |i|
    var note = 60 + i;
    Button(w, Rect(i*50, 0, 50, 50)).states_([
        [
            note.midinote[0..1],
            Color.white,
            Color.hsv(i/12, 0.7, 0.4)
        ]
    ]).action_{
        {Pulse.ar(note.midicps)*EnvGen.kr(Env.perc, doneAction: 2)}.play;
    };
}
)

// glissando

// curva che si muove tra 200 e 300 Hz per un totale di 20sec
({
    var levels, times, env;
    levels = Array.fill(50, {arg x; (x%7) * (x%3)}).normalize;
    times = Array.fill(49, 1).normalizeSum;
    env = Env.new(levels, times);

    Pulse.ar(EnvGen.kr(envelope: env, gate: 1, levelScale: 100, levelBias: 200, timeScale: 20, doneAction: 2))
}.play;)

//
({
    var levels, times, env;
    levels = Array.fill(50, {arg x; (x%7) + (x%3)}).normalize;
    times = Array.fill(49, 1).normalizeSum;
    env = Env.new(levels, times);

    Saw.ar(
        Latch.kr(
            EnvGen.kr(envelope: env, gate: 1, levelScale: 24, levelBias: 60, timeScale: 10, doneAction: 2),
            trig: Impulse.kr(3)
    )) * 0.5;
}.play;)

{LFSaw.ar(600)*0.2}.scope;
{SinOsc.ar(freq: 440 + LFSaw.kr(2, mul:50), mul: 0.5)}.plot(0.05);

{LFNoise0.ar(600)}.scope;
{SinOsc.ar(freq: 440 + LFNoise0.kr(2, mul:50), mul: 0.5)}.play;

{LFNoise1.ar(600)}.scope;
{SinOsc.ar(freq: 440 + LFNoise1.kr(2, mul:50), mul: 0.5)}.play;

{SinOsc.ar(LFNoise0.kr(9, 400, 500), 4, 0.2)}.play;
{
    SinOsc.ar(
        Latch.kr(
            LFnoise1.kr,
            Impulse.kr(9)
    )*400+500,4,0.2)
}.play;

// Improvvisatori
(
SynthDef(\chromaticImproviser, {
    arg freq = 10;

    Out.ar(0, SinOsc.ar(
        freq: LFNoise0.kr(freq, mul:15, add:60).round.midicps,
        mul: EnvGen.kr(Env.perc(0.05), gate: Impulse.kr(freq), doneAction: 2))
    );
}).play;
)

(
SynthDef(\modalImproviser, {
    arg freq = 10;

    var scale = [0,0,0,0, 3,3, 4,5,5,6,6,7,7,7,10]+60; // 60 è il do centrale
    var mode = scale.addAll(scale+12).midicps; //incremento ottava in midi, convertito in Hz attraverso midicps
    var range = (mode.size*0.5).asInteger;

    Out.ar(0, SinOsc.ar(
        freq: Select.kr(LFNoise0.kr(freq,
            mul: range,
            add:range).round, mode),
        mul: EnvGen.kr(Env.perc(0.05), gate: Impulse.kr(freq), doneAction:2)
    ));
}).play;
)

{
    Dust.ar(MouseX.kr(1, 500))
}.play;

({
    var trig = Impulse.kr(9);
    SinOsc.ar(
        TRand.kr(100, 900, trig)
    ) * 0.1;
}.play;)

({
    var trig = Dust.kr(9);
    SinOsc.ar(
        TRand.kr(100, 900, trig)
    ) * 0.1;
}.play;)