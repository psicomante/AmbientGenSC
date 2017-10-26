//SymthDef - Recipe For a particular sound

s.boot;

(
z = {
    arg noiseHz = 8;
    var freq, amp, sig;
    freq = LFNoise0.kr(noiseHz).exprange(200,1000);
    amp = LFNoise1.kr(12).exprange(0.02, 1);
    sig = SinOsc.ar(freq) * amp;
}.play;'
)

(
SynthDef.new(\sineTest, {
    arg noiseHz = 8;
    var freq, amp, sig;
    freq = LFNoise0.kr(noiseHz).exprange(200,1000);
    amp = LFNoise1.kr(12).exprange(0.02, 1);
    sig = SinOsc.ar(freq) * amp;

    Out.ar(0, sig); // 0 is the lowest hardware outputs available
    // normally 0 is the left speaker, 1 the right one
}).add;
)

x = Synth.new(\sineTest, [\noiseHz, 300]);
x.set(\noiseHz, 10);
x.free;

// SynthDef Pulse!
(
SynthDef.new(\pulseTest, {
    arg ampHz=4, fund=40, maxPartial=4, width=0.5;
    var amp1, amp2, freq1, freq2, sig1, sig2;

    amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
    amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;

    freq1 = LFNoise0.kr(ampHz).range(fund, fund*maxPartial).round(fund);
    freq2 = LFNoise0.kr(ampHz).range(fund, fund*maxPartial).round(fund);

    freq1 = freq1 * LFPulse.kr(ampHz*2, add:1).poll(10, label: \LFPulse);
    freq2 = freq2 * LFPulse.kr(ampHz*3, add:1);

    sig1 = Pulse.ar(freq1, width, amp1);
    sig2 = Pulse.ar(freq2, width, amp2);

    sig1 = FreeVerb.ar(sig1, MouseY.kr(0,1), MouseX.kr(0,1), 0.2);
    sig2 = FreeVerb.ar(sig2, MouseY.kr(0,1), MouseX.kr(0,1), 0.2);

    Out.ar(0, sig1);
    Out.ar(1, sig2);
}).add;
)
x  = Synth.new(\pulseTest);
x.set(\maxPartial, 24);
z = Synth.new(\pulseTest, [\maxPartial, 6]);
x.set(\maxPartial, 6);
x.free;
z.free;

y = Synth.new(\pulseTest, [\ampHz, 3, \maxPartial, 6, \width, 0.1]);

{ LFNoise0.ar(4).exprange(40,400).poll(1000, label: \LFNoise) }.plot(1);
