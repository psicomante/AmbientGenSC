/*
Ring Modulation
A straight multiplication of two signals.
carrier * modulator
*/
(
{
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= SinOsc.ar(carrfreq,0,0.5);
modulator= SinOsc.ar(modfreq,0,0.5);

carrier*modulator;
}.scope
)
/*
For simple sine waves, the spectrum ends up with two frequencies (two sidebands), at C+M and C-M, where C is the carrier frequency and M is the modulator frequency.

For more complex waves than sines, we get many more components to the spectrum of the multiplied signals.

But if C and M are harmonic, the sidebands are also harmonic.

For those who want to see some proof, it all follows from the mathematical relation

cos(C)*cos(M) = 0.5*(cos(C-M) + cos(C+M))
*/

/*************************************/
/*** AMPLITUDE MODULATION AM ***/
/*************************************/
// AM is like ring modulation but with a subtle difference: the modulator is unipolar, that is, always positive. Think of tremolo, where the amplitude goes up and down (but is never negative!).

{SinOsc.ar(440,0,0.5)}.scope //bipolar, -0.5 to 0.5

{SinOsc.ar(440,0,0.5,0.5)}.scope //unipolar, 0 to 1 (0.5 plus or minus 0.5)

(
{
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= SinOsc.ar(carrfreq,0,0.5);
modulator= SinOsc.ar(modfreq,0,0.25, 0.25);

carrier*modulator;
}.scope
)

/**The spectrum ends up with the sum and difference frequencies we saw in ring modulation, at C+M and C-M, as well as the original carrier frequency C.

The maths is now:

cos(C)*(1+cos(M)) = cos(C)+ 0.5*(cos(C-M) + cos(C+M))
*/

///////////////////////////
//Frequency Modulation (FM)
///////////////////////////

/*FM was applied to sound synthesis by John Chowning in 1967, though he published his results in 1973. Yamaha licensed the patents and in 1983 released the Yamaha DX7 synthesiser, which went on to sell 300,000 units, the most commercially successful synthesiser of all time.

You might know the 'slow version' of FM already: a vibrato.

Rather than plugging the modulator into the amplitude of the carrier, we're going to plug the modulator into the carrier frequency. There will be three parameters, the carrier frequency C, the modulation frequency M, and the modulation depth or frequency deviation D.
*/

// 60, 278, 741

(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w=Window("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, moddepth=0.01;
SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
moddepthslider= EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez|  synth.set(\moddepth, ez.value)});

w.front;
)

/*In the spectrum now, there are an infinite number of sidebands, but of varying strength. Based on the values we choose for the parameters C, M and D we can make very thick spectrums, or only a light modulation effect. The sidebands turn up at

C + kM where k is any integer, ie. C. C+M, C-M, C+2M, C-2M, ...

By changing the modulation frequency and depth, you can see how the energy in the sidebands is redistributed; the actual formulas for this use Bessel functions and are outside the scope of this lecture: but see the Roads Computer Music Tutorial if you're curious.

*/

(
var w, carrfreqslider, modfreqslider, modindexslider, synth;

w=Window("frequency modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, modindex=0;
SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 10, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});

w.front;
)

//or via mouse control
(
{
var modfreq, modindex;

modfreq= MouseX.kr(1,440, 'exponential');
modindex=MouseY.kr(0.0,10.0);

SinOsc.ar(SinOsc.ar(modfreq,0,modfreq*modindex, 440),0,0.25)
}.scope
)