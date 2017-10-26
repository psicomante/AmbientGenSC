{WhiteNoise.ar(0.1)}.scope;

// Low Pass filter, frequency cut
{LPF.ar(WhiteNoise.ar(0.1), 1000)}.scope;

Line.kr(10000,1000,10);
// varying
({
    n = WhiteNoise.ar(0.1);
    l = Line.kr(10000, 1000, 10);
    LPF.ar(n,l)
}.play)

/*
Oscillators
[Saw]
[Blip]

Noise Sources
[PinkNoise]
[LFNoise0]

some example filters:
[HPF]
[BPF]
[Resonz]
*/


// Filtering
{LFNoise0.ar(400)}.play
{Resonz.ar(LFNoise0.ar(400),1000,0.1)}.scope

{Resonz.ar(LFNoise0.ar(400),Line.kr(10000,1000,10),0.1)}.scope

(
{
var source, line, filter; 	//local variables to hold objects as we build the patch up

source=LFNoise0.ar(400);
line=Line.kr(10000,1000,10);
filter=Resonz.ar(source,line,0.1); //the filtered output is the input source filtered by Resonz with a line control for the resonant frequency

filter // last thing is returned from function in curly brackets, i.e. this is the final sound we hear
}.scope;
)

/*** ADDITIVE *****/

{SinOsc.ar}.scope //defaults to a concert A (440Hz)
{SinOsc.ar(400,0,0.1) + SinOsc.ar(660,0,0.1)}.scope
{SinOsc.ar([400,660],0,0.1)}.scope

// Pan takes a mono signal a put it to stereo
{Pan2.ar(WhiteNoise.ar(0.1), MouseX.kr(-1,1))}.scope

{Mix(SinOsc.ar([400,660],0,0.1))}.scope //a two channel signal put through Mix turns into mono

{Pan2.ar(Mix(SinOsc.ar([400,660],0,0.1)),MouseX.kr(-1,1))}.scope //a two channel signal put through Mix turns into mono

// Sawtooth Wave
//Sawtooth wave: Add up n harmonics with amplitude falling off as 1/harmonicnumber, sign alternates between +1 and -1


(
{
	var n = 10;

	var wave = Mix.fill(10,{|i|
    	var mult= ((-1)**i)*(0.5/((i+1)));
    	SinOsc.ar(440*(i+1))*mult
    });
	Pan2.ar(wave/n,0.0); //stereo, panned centre

}.scope;
)

// Square Wave
// Square wave: Sum of odd harmonics, no even, amplitude falls as off 1/harmonicnumber; closest 'real' waveform is a clarinet tone
(
{
	var n = 10;

	var wave = Mix.fill(10,{|i|
			var harmonicnumber = 2*i+1; //odd harmonics only
			SinOsc.ar(440*harmonicnumber)/harmonicnumber
		})*0.25;

	Pan2.ar(wave,0.0); //stereo, panned centre

}.scope;
)

// triangle ave
// Triangle wave: also odd harmonics only, falls off as 1 over harmonicnumber squared with alternating sign

(
{
	var n = 10;

	var wave = Mix.fill(10,{|i|
		var harmonicnumber= 2*i+1; //odd harmonics only
    	var mult= ((-1)**((harmonicnumber-1)/2))*(1.0/(harmonicnumber*harmonicnumber));

    SinOsc.ar(440*i)*mult })/n;

	Pan2.ar(wave,0.0); //stereo, panned centre

}.scope;
)

// Bell Sound
{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1))}.scope //bell spectra, all partials the same volume

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope //bell spectra, different volumes for partials

(
var n = 10;
{Mix(SinOsc.ar(250*(1..n),0,1/n))}.scope;
)

(
{
	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700
	var cutoff = 	SinOsc.ar(1,mul:MouseX.kr(0.0,1700.0), add:2000.0);
	//var cutoff = SinOsc.ar(1)*1700.0 + 2000.0;  //same thing
	LPF.ar(WhiteNoise.ar,freq:cutoff);
}.scope
)


//filter example rewritten:
(
{
	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700
	//var cutoff = 	SinOsc.ar(1,mul:MouseX.kr(0.0,1700.0), add:2000.0);
	var cutoff = SinOsc.ar(1)*1700.0 + 2000.0;  //same thing
	LPF.ar(WhiteNoise.ar,freq:cutoff);
}.scope
)

{SinOsc.ar(SinOsc.ar(3,mul:40,add:440),0,0.1)}.scope