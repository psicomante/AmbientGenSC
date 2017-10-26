FreqScope.new(400, 200, 0, server:s);

{SinOsc.ar(200, 0, 0.25)}.play;
{ RLPF.ar(Saw.ar(110, 0.2), LFNoise2.kr(1,1e4,1e4), LFNoise2.kr(1, 0.2, 0.22)) }.play(s);

{ Blip.ar(200, Line.kr(1, 100, 10), 0.2) }.play(s);

{ SinOsc.ar(800, SinOsc.ar(XLine.kr(20, 8000, 10), 0, 2pi), 0.25) }.play(s);

{Resonz(WhiteNoise.ar(0.5), 2000, 0.1)}.play;
{ Resonz.ar(WhiteNoise.ar(0.5), 2000, 0.1) }.play

({FreqShift.ar(
    LPF.ar(PinkNoise.ar(0.025), 5000),
    SinOsc.ar(5, mul:50, add: 500),
    0,
    [32,32])}.play(s);)


// read a soundfile
(
f = SoundFile.new;
f.openRead(thisProcess.nowExecutingPath.dirname +/+ "ocean1.wav");
f.play;
)



plot({ Decay.ar(Impulse.ar(1), 0.01) });

{Impulse.ar(440)}.play
{Decay.ar(Impulse.ar(440), 4)}.play

{BrownNoise.ar(0.015)}.play;
{HPF.ar(WhiteNoise.ar, 1000) * LFNoise2.kr(1).squared.squared}.play;
{WhiteNoise.ar * Line.ar(1,0,0.02, doneAction: 2)}.plot(0.02);
{LFNoise0.kr(1)}.plot(10);