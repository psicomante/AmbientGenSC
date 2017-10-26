(r = Routine({
    "abcde".yield;
    "fghij".yield;
    "klmno".yield;
    "pqrst".yield;
    "uvwxy".yield;
    "z{|}~".yield;
});

t = Task({
    var delta;
    while {
        delta = r.next;

        if(delta.isNil, {
            r.reset;
            delta = r.next;
        });
        delta.notNil;
    } {
        delta.postln;
        1.yield;
    };


}).play(quant: TempoClock.default.beats + 1.0);
)



(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
    Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;

r = Routine({
    var delta;
    loop {
        delta = rrand(1, 3) * 0.5;
        Synth(\singrain, [freq: exprand(200, 800), amp: rrand(0.1, 0.5), sustain: delta * 0.8]);
        delta.yield;
    }
});
)

r.play;

SynthDef(\testFun, {
    var sou = SinOsc.ar;

    Out.ar(0, Mix.ar(sou)*0.3);
}).add;

x = Synth(\testFun);

{
    s = SinOsc.ar;
    Pan2.ar(s);
}.plot(0.1, numChannels: 2);
/////

(
t = Task({
    loop {
        [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
            Synth(\harp, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
            1.wait;
        });
    }
}).play;
)



//////

(
var midi, dur;
midi = Routine({
    [60, 72, 71, 67, 69, 71, 72, 60, 69, 67].do({ |midi| midi.yield });
});
dur = Routine({
    [2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3].do({ |dur| dur.yield });
});

SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.5|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2);
    Out.ar(0, sig ! 2)
}).add;

SynthDef(\harp, {
    arg freq = 440, sustain = 10, amp = 0.5;

    var sig = Pluck.ar(
        in: WhiteNoise.ar(0.1),
        trig: Impulse.kr(2),
        maxdelaytime: freq.reciprocal,
        delaytime: freq.reciprocal,
        decaytime: sustain,
        coef:amp
    ) !2;

    Out.ar(0, EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2)* sig);
}).add;

r = Task({
    var delta;
    while {
        delta = dur.next;

        if(delta.isNil, {
            dur.reset;
            midi.reset;

            delta = dur.next;
        });

        delta.notNil
    } {
        Synth(\harp, [freq: midi.next.midicps, sustain: delta]);
        delta.yield;
    };

    dur.reset;
    midi.reset;

}).play(quant: TempoClock.default.beats + 1.0);
)