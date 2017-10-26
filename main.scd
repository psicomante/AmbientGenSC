/*
  ***************************************************
  *** Digital Sound and Music Processing Course ***
  *** Roberto Pesando Project ***

  *** USAGE ***
  *** Compile Into Server ***
  *** 1- Global Dictionary
  *** 2- Synth Definitions
  *** 3- Routines / Tasks
  *** 4- GUI
  ***************************************************
*/


/*
  *** Global Variables Dictionary ***
*/
(
~global=(
    bus: (
        wind: Bus.audio(s,2),
        water: Bus.audio(s,2),
        fire: Bus.audio(s,2),
        ocean: Bus.audio(s,2),
        harp: Bus.audio(s,2),
        boat: Bus.audio(s,2)
    ),
    task: (
        harp: nil,
        ocean: nil
    ),
    synth: (
        main: nil,
        wind: nil,
        boat: nil,
        water: nil,
        fire: nil
    ),
    defaultValues: (
        windVol: 0.3,
        oceanVol: 0.5,
        boatVol: 0.2,
        waterVol: 0.3,
        fireVol: 0.3,
        harpVol: 0.5,
        swingingSpeed: 0.1,
        windPitch: 500
    )
);
)


/*
  *************************
  *** Synth Definitions ***
  *************************
*/

/*
  *** Fire SynthDef ***
*/
(
SynthDef(\fire, {
    arg out = 0,
    // hissing frequency
    hFreq = 1,
    hAmp = 0.1,
    // Hissing Intensity
    hInt = 4,
    // Crackle Amplitude
    crackleAmp = 0.1,
    flameAmp = 0.6,
    bandPassFreq = 600, // 1200, 2600
    q = 0.2; // 0.6, 0.4

    var noise, hissing, crackling, lapping, sig;
    var hFreqM, trigs, durScale, resFreq;

   	noise = WhiteNoise.ar;

    hFreqM = LPF.kr(WhiteNoise.kr, hFreq);
    hFreqM = (hFreqM * hInt).squared * (hInt*50);
    hissing =  (WhiteNoise.ar(hFreqM)*hAmp/10);
    hissing = HPF.ar(noise, 2000) * LFNoise2.kr(hFreq).squared.squared;

    // Crackle
	trigs = Dust.kr(hFreq*TExpRand.kr(1, 2)); // trigger generator
	durScale = TRand.kr(1, 1.5, trigs); // generator duration between 20ms and 30ms
    resFreq = TExpRand.kr(100, 1000, trigs); // frequency range
    crackling = noise * EnvGen.ar(Env.perc(0, TExpRand.kr(0.01, 0.05)), trigs, timeScale: durScale);
	crackling = BPF.ar(crackling, resFreq, 10);
	// Flame
    lapping = HPF.ar((BPF.ar(noise, 30, 0.2) * 50), 5000);
    sig =  ([hissing, crackling, lapping] * [hAmp, crackleAmp, flameAmp]).sum * 3;
    sig = BPF.ar(sig,  bandPassFreq, 1/q);

    Out.ar(out, sig);
}).add;


/*
  *** Wood Creacking ***
*/
SynthDef(\sailboat, {
    arg swingingSpeed = 0.1, out = 0;

    var freqs, rqs, sound, gate, env;

   freqs = [62.5, 125, 250, 395, 560, 790, 1050];
    rqs   = 1 / [1, 1, 2, 2, 3, 3, 3];

    gate = Impulse.kr(SinOsc.kr(swingingSpeed).range(1,swingingSpeed*100));
    env = EnvGen.kr(Env.adsr(0, 0, 0.01, 0.1, curve: \linear), gate, doneAction: 0, levelScale: 5);

    sound = BPF.ar(BrownNoise.ar * env, freqs, rqs);
    sound = BPF.ar(sound, freqs, rqs).sum + (sound*0.2);
    sound = FreeVerb.ar(sound, 0.1, 0.01, 0.3);
    Out.ar(out, sound);
}).add;

/*
  *** Ocean SynthDef ***
*/
SynthDef(\ocean1, {
    arg lowCut = 8000, highCut = 20000, oceanSustainTime = 1, out = 0;
    var noise, freqEnv, ampEnv, env, sound;

    // base noise
    noise = PinkNoise.ar(0.5);

    env = Env.linen(1.0, 0.5, 4.5, 0.8, \sin);

    // Frequency Envelope
    freqEnv = EnvGen.ar(
        env.range(lowCut, highCut), timeScale: oceanSustainTime,
    );
    // Amplitude Envelope
    ampEnv = EnvGen.ar(
        env,
        doneAction: 2
    );

    // varying low pass filter based on the envelope
    sound = LPF.ar(noise, freqEnv);

    Out.ar(out, Pan2.ar(sound*ampEnv, ampEnv));
}).add;

/*
  *** Water SynthDef ***
*/
SynthDef(\runningWater, {

    arg out = 0,
    // Crackle Amplitude
    crackleAmp = 0.5, //
    // Crackle Stochastic Density (imp per sec)
    crackleDensity = 0.7,
	white_amp = 0.1,
	one_coef  = 0.7,
	freq_range = (4..7);

    var sig;

    //Generate white noise with a little crackle
    sig = OnePole.ar(WhiteNoise.ar(white_amp)+Dust.ar(crackleDensity*100, crackleAmp), 0.5);

    //Shift the white noise from left to right channels
    sig = sig + Splay.ar(FreqShift.ar(sig, 1/freq_range));
	Out.ar(out, sig);
}).add;

/*x = Synth(\runningWater, [\crackleAmp, 0.5]);
x.set(\crackleAmp, 0.1);
x.set(\crackleDensity, 100);
x.set(\one_coef, 0.7);*/

/*
  *** Wind SynthDef ***
*/
SynthDef(\wind, {
    arg out = 0, windPitch = 500;

	var windspd, snd;
	windspd = LFDNoise3.kr(LFNoise0.kr(1, 0.5, 0.5), 0.5, 0.5);

    // Panning and Rensonance
	snd = Pan2.ar(
        RLPF.ar(in:PinkNoise.ar, freq:windspd * windPitch + (windPitch/2), rq:LFNoise1.kr(1, 0.3, 0.5), mul:windspd * 0.5),
        LFDNoise3.kr(0.4, 0.5)
    );
	Out.ar(out, snd);
}).add;

// Harp Sound
SynthDef(\harp, {
    arg freq = 440, sustain = 10, out = 0;

    var sig = Pluck.ar(
        in: WhiteNoise.ar(0.1),
        trig: Impulse.kr(2),
        maxdelaytime: freq.reciprocal,
        delaytime: freq.reciprocal,
        decaytime: sustain,
        coef: 0.5
    ) !2;

    Out.ar(out, EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2) * sig);
}).add;

/*
  *** Main SynthDef ***
// Sound Collector for Volume Mixing and Peak Limiting
*/
SynthDef(\main, {
    arg windVol = 0.5, fireVol = 0.5, oceanVol = 0.5, waterVol = 0.5, harpVol = 0.5, boatVol = 0.5;

    var wind, runningWater, output, fire, harp, boat, ocean;

    // collect from Wind bus
    wind = In.ar(~global[\bus][\wind].index, 2)*windVol;

    // collect from Running Water
    runningWater = In.ar(~global[\bus][\water].index, 2)*waterVol;

    // collect from fire
    fire = In.ar(~global[\bus][\fire].index, 2)*fireVol;

    // collect from harp
    harp = In.ar(~global[\bus][\harp].index, 2)*harpVol;

    // collect from boat
    boat = In.ar(~global[\bus][\boat].index, 2)*boatVol;

    // collect from ocean
    ocean = In.ar(~global[\bus][\ocean].index, 2)*oceanVol;

    // Mix
    output = Mix([wind, runningWater, fire, harp, boat, ocean]);
    output = Limiter.ar(output, 0.99);

    Out.ar(0,output);
}).add;
)



/*
  *************************
  *** Tasks / Routines ***
  *************************
*/
(

// Harp Task
~global[\task][\harp] = Task({
    var midi, dur, delta;

    // Notes Routine
    midi = Routine({
        [60, 72, 71, 67, 69, 71, 72, 60, 69, 67].do({
            arg midi;
            midi.yield;
        });
    });

    // Duration Routine
    dur = Routine({
        [2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3].do({
            arg dur;
            dur.yield
        });
    });

    while {
        delta = dur.next;

        if(delta.isNil, {
            dur.reset;
            midi.reset;

            delta = dur.next;
        });

        delta.notNil
    } {
        Synth(\harp, [out: ~global[\bus][\harp].index, freq: midi.next.midicps, sustain: delta]);
        delta.yield;
    };

    dur.reset;
    midi.reset;
});

// Ocean Tasks
~global[\task][\ocean] =Task({
    loop {
        [4000, 7000, 8000].do({
            arg waves;

            var ocean, waitTime;
            var cutLow = 2000.rand + 6000;
            var cutHigh = 15000 + 5.rand;

            Synth(\ocean1, [
                freq: waves.midicps,
                lowCut: cutLow,
                highCut: cutHigh,
                oceanSustainTime: 1.rand + 1,
                out: ~global[\bus][\ocean].index
            ]);

            waitTime = 12.rand + 5;
            waitTime.wait;
        });
    }
});

)

/*
  *************************************************
  *** GUI - Graphical User Interface ***
  *** and Ambient Music Generator Controllers ***
  *************************************************
*/
(
var win, playButton;
// Wind Variables
var windVolume, windLabel, windVolumeLabel;
// Ocean Waves Variables
var oceanVolume, oceanLabel, oceanVolumeLabel;
// Running Water Variables
var waterVolume, waterLabel, waterVolumeLabel, crackleAmp, crackleDensity;

// GUI Functions
var createLabel = {
    arg text = "Text", size = 14;
    StaticText().string_(text).font_(Font("Helvetica", size));
};
var createSlider = {
    arg synth, synthArg, loValue = 0.0, hiValue = 1.0, default = 0.5, set = true;

    if (set == true, {
        default = ~global[\defaultValues][synthArg];
    });

    Slider().action_({
        arg me;

        var value = (abs(hiValue - loValue)*me.value) + loValue;
        value.postln;

        if (set == true, {
            ~global[\defaultValues][synthArg] = value;
        });

        ~global[\synth][synth].set(synthArg, value);
    }).value_(default).orientation_(\horizontal);
};

// Play and Stop Generator Functions
var playGen = {
    // water
    ~global[\synth][\water] = Synth.new(
        \runningWater,
        [\out: ~global[\bus][\water]]
    );

    // wind
    ~global[\synth][\wind] = Synth.after(
        ~global[\synth][\water],
        \wind,
        [
            \out: ~global[\bus][\wind],
            \windPitch: ~global[\defaultValues][\windPitch]
        ]
    );

    // sailboat
    ~global[\synth][\boat] = Synth.after(
        ~global[\synth][\wind],
        \sailboat,
        [
            \out: ~global[\bus][\boat],
            \swingingSpeed: ~global[\defaultValues][\swingingSpeed]
        ]
    );

    // fire
    ~global[\synth][\fire] = Synth.after(
        ~global[\synth][\boat],
        \fire,
        [\out: ~global[\bus][\fire]]
    );

    // setting up Main and default volumes
    ~global[\synth][\main] = Synth.after(~global[\synth][\fire], \main, [
        windVol: ~global[\defaultValues][\windVol],
        waterVol: ~global[\defaultValues][\waterVol],
        oceanVol: ~global[\defaultValues][\oceanVol],
        fireVol: ~global[\defaultValues][\fireVol],
        harpVol: ~global[\defaultValues][\harpVol],
        boatVol: ~global[\defaultValues][\boatVol],
    ]);

    // Harp Notes
    ~global[\task][\harp].reset;
    ~global[\task][\harp].play(quant: TempoClock.default.beats + 1.0);

    // Ocean
    ~global[\task][\ocean].reset;
    ~global[\task][\ocean].play;

    //create a node watcher for meaningfull isRunning
    NodeWatcher.register(~global[\synth][\main], true);
};

var stopGen = {
    ~global[\synth][\wind].free;
    ~global[\synth][\water].free;
    ~global[\synth][\fire].free;
    ~global[\synth][\boat].free;
    ~global[\synth][\main].free;

    // Harp Notes
    ~global[\task][\ocean].stop;
    ~global[\task][\harp].stop;
};

var freeGen = {

};

// Main Window
win = Window.new("Ambient Music Generator", Rect(200,200,400,200));

// playButton Definition and Action
playButton = Button().states_([
    ["Play", Color.white, Color.new255(82,215,213)],
    ["Stop", Color.gray, Color.new255(200,215,213)]
]).maxWidth_(100);

playButton.action_({
    arg me;

    var val = me.value.postln;
    if (val == 0) {
        stopGen.value();
    } {
        playGen.value();
    }
});

// GUI Layout
win.layout_(
    VLayout(
        // Play Button
        playButton,

        // Wind GUI
        VLayout(
            createLabel.value("Wind"),
            HLayout(
                createLabel.value("Volume"),
                createSlider.value(\main, \windVol)
            ),
            HLayout(
                createLabel.value("Pitch"),
                createSlider.value(\wind, \windPitch, 100, 2000)
            )
        ),

        // Ocean Waves GUI
        VLayout(
            createLabel.value("Ocean Waves", 25),
            HLayout(
                createLabel.value("Volume"),
                createSlider.value(\ocean, \oceanVol)
            )
        ),

        // River / Water GUI
        VLayout(
            createLabel.value("River", 25),
            HLayout(
                createLabel.value("Volume"),
                createSlider.value(\main, \waterVol, 0, 0.5);
            ),
/*            HLayout(
                createLabel.value("Crackle Amplitude"),
                createSlider.value(\water, \crackleAmp, 0.1, 10);
            )*/
        ),

        // Fire GUI
        VLayout(
            createLabel.value("Fire", 25),
            HLayout(
                createLabel.value("Volume"),
                createSlider.value(\main, \fireVol, loValue: 0, hiValue: 5);
            ),
        ),

        // Harp GUI
        VLayout(
            createLabel.value("Harp", 25),
            HLayout(
                createLabel.value("Volume"),
                createSlider.value(\main, \harpVol, loValue: 0, hiValue: 5)
            ),
        ),

        // SailBoat Creaking
        VLayout(
            createLabel.value("Sail Boat Creaking", 25),
            HLayout(
                createLabel.value("Volume"),
                createSlider.value(\main, \boatVol)
            ),
            HLayout(
                createLabel.value("Swinging Speed"),
                createSlider.value(\boat, \swingingSpeed, 0.001, 0.5)
            ),
        )
    ),

);

// Window Settings
win.front;
win.alwaysOnTop_(true);
win.onClose_({
    if (~global[\synth][\main].isRunning, {
        stopGen.value();
    });
});
)

// Frequency Spectrum Visualizer
(
f = FreqScope.new(400, 200, 0, server:s);
f.window.alwaysOnTop_(true);
)

(SynthDescLib.global.browse;)