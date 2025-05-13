s.options.memSize = 40 * 1024;
s.reboot;
(
var creepyVocalBuf = Buffer.readChannel(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/creepy-vocals.wav', channels: [0]);
var score = Buffer.read(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/score.flac');
SynthDef(\score, { | out = 0, trig = 1, amp = 1 |
	Out.ar(out, PlayBuf.ar(2, score, BufRateScale.ir(score), trig, doneAction: 2) * amp)
}).add;
SynthDef(\phatBass, { | out = 0, freq = 60, gate = 1, amp = 0.2, pan=0 |
	var env = EnvGen.kr(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	var modEnv = EnvGen.kr(Env([0, 1, 0], [0.2, 1], \squared), gate);
	var sig = Saw.ar(freq + (Rand(-1, 1 ! 20)  * freq / 40), amp) + Saw.ar(freq * 2 + (Rand(-1, 1 ! 20)  * freq / 40), amp);
	sig = sig + WhiteNoise.ar(0.2);
	sig = LPF.ar(sig, 200 + (modEnv * 600));
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;

SynthDef(\introSwoop,{ | out = 0, amp = 1, release=1, trig=1, freq |
	var env = EnvGen.kr(Env([0.01, 1, 0], [release, 0], 5 ), 1, doneAction: 2);
	var sig = PlayBuf.ar(1, creepyVocalBuf, BufRateScale.ir(creepyVocalBuf), trig) * 4;
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4 ! 10), 0);
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4));
	sig = Splay.ar(sig) * env * amp;
	Out.ar(out, sig);

}).add;
SynthDef(\introSustain,{ | out = 0, amp = 0.2, gate=1, freq=400, combAmount=0 |
	var env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
	var sig = PlayBuf.ar(1, creepyVocalBuf, BufRateScale.ir(creepyVocalBuf), gate, loop: 1) * 4;
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4 ! 10), 0);
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4));
	sig = Splay.ar(sig) * env;
	sig = CombC.ar(sig, 0.2, 1/freq, LFNoise2.kr(0.2).range(0.1, 4)) * combAmount + sig;
	sig = Limiter.ar(sig, 0.5, 0.01);
	sig = sig * amp;
	Out.ar(out, sig);

}).add;
SynthDef(\ride, { |out = 0, amp = 0.2, pan = 0.5, bandFreq=8000, releaseTime = 1 |
	var env = EnvGen.kr(Env.perc(0.00, releaseTime, 1, -6), 1, doneAction: 2);
	var sig = BPF.ar(WhiteNoise.ar(1), bandFreq, 1.0);
	sig = sig + CombC.ar(sig, 0.1, 0.1, 10);
	Out.ar(out, Pan2.ar(
		sig
		, pan, amp * env))
}).add;
SynthDef(\marimba, { | out = 0, amp = 0.2, pan = 0.5, freq=440, trig=1 |
	var env = EnvGen.kr(Env.perc, trig);
	var sig = Mix.ar(
		SinOsc.ar(freq, 0, 1) +
		SinOsc.ar(freq + Rand(0, freq ! 4), 0, Rand(0.2, 1))) * env;
	sig = BPF.ar(sig, 440) + BPF.ar(sig, 800);
	Out.ar(out, FreeVerb.ar(Pan2.ar(sig, pan, amp)));
}).add;
SynthDef(\drumstick, { | out = 0, trig = 1, amp = 0.4 |
	Out.ar(out, EnvGen.ar(
		Env.perc(
			0.001 * Rand(1, 2),
			0.001 * Rand(1, 2)),
		trig, doneAction: 2) * amp * 0.5)
}).add;
SynthDef(\tom, { | out = 0, in, pan, freq = 100, freqSpread = 5000, decayTime = 0.4, gate=1 |
	var input = In.ar(in);
	var env = EnvGen.kr(Env.asr(0.0, 1, 0.1), gate, doneAction: 2);
	var sig = Ringz.ar(input, freq + (Rand(0, 1 ! 70) * freqSpread), decayTime).mean * env;
	//sig = sig + input;
	sig = PanAz.ar(s.options.numOutputBusChannels, sig, pan, orientation: 0);
	Out.ar(out, sig);

}).add;
/*SynthDef(\bell, { | out = 0, pan = 0, amp = 0.2, freq=200, trig=1, decayTime=4 |
var env = EnvGen.kr(Env([0, 1, 1, 0], [0, decayTime+0.1,0.1]), trig, doneAction: 2);
var sig = Mix.ar(Ringz.ar(EnvGen.ar(Env.perc(0.01, 0.01), trig), ExpRand(freq, freq+ 2000 ! 4), decayTime, 0.1 ));
sig = sig * env;
Out.ar(out, Pan2.ar(sig, pan, amp))
}).add;*/
TempoClock.tempo = 132 / 60;
Pdef(\section1,
	Pseq([
		Ppar([
			Pbind(
				\instrument, \introSwoop,
				\dur, Pseq([5]),
				\release, Pseq([5 / TempoClock.tempo]),
				\amp, 2
			),
			Pbind(
				\instrument, \ride,
				\bandFreq, Pseq([
					Pseg([400, 10000], [5], \exp)
				]),
				\releaseTime, 0.1,
				\dur, Pseq([
					Pseq([0.25], 16), Pseq([0.125], 8)
				]),
				\amp, Pseg([0.05, 0.2], [5])
			)
		]),
		Ppar([
			Pbind(
				\instrument, \score,
				\dur, 1,
				\freq, Pseq([20]),
				\amp, 0.5
			),
			Pbind(
				\instrument, \phatBass,
				\freq, Pseq([27, 25, 27, 25, 27].midicps),
				\dur, Pseq([25, 10, 5, 20.5, 2]),
				\amp, 0.2
			),
			Pbind(
				\instrument, \ride,
				\bandFreq, Pseq([
					Pseg([10000, 400], [25], \exp),
					Pseg([10000, 400], [10], \exp),
					Pseg([10000, 400], [5], \exp),
					Pseg([10000, 400], [20.5], \exp),
					Pseg([8000, 8000], [2])
				]),
				\releaseTime, Pseq([
					Pseg([0.1, 4], [25], \exp),
					Pseg([0.1, 4], [10], \exp),
					Pseg([0.1, 4], [5], \exp),
					Pseg([0.1, 4], [20.5], \exp),
					Pseg([0.1, 0.1], [2])
				]),
				\dur, Pseq([
					Pseq([0.25], 60 * 4 + 2),
					Pseq([0.125], 16)
				]),
				\pan, Pseq([-0.25, 0.25], inf)
			),
			Pbind(
				\instrument, \introSwoop,
				\dur, Prand([0.25, 1, 2, 10], inf)
			)
		])
	])
)
)

Synth(\introSustain)
(Pbind(
	\instrument, \ride,
	\dur, Pseq([0.25], inf)
).play;)
x  = Synth(\phatBass, [\freq, 40.midicps])
x.release
x = Synth(\introSustain, [\freq, 60.midicps, \combAmount, 0.4])
x.release;

(~tomBuses = 20.collect({ Bus.audio(s, 1) });
	~drumGroup = Group(s, \addToHead);
	~stickGroup = Group(s, \addToHead);
	~ig = Group(s, \addToHead);
~createDrums.(13);
~toms.collect { | tom | tom.set(\freq, rrand(20, 4000)) };
~toms.collect { | tom | tom.set(\freqSpread, rrand(400, 3000)) };
~toms.collect { | tom | tom.set(\pan, rrand(-1.0, 1)) };
)
~toms.collect { | tom | tom.set(\amp, 0.8) }
Synth(\drumstick, [\out, ]);
(Pdef(\section2,
	Pbind(
		\instrument, \drumstick,
		\out, Pfunc({ ~tomBuses.[rrand(0, 12)] }),
		\dur, 0.25,
		\amp, 0.3

	)
).play;)
(
Task({
	// Opening Phrase
	Pdef(\section1).play;
	62.5.wait;
	Pbind(
		\instrument, \introSwoop,
		\dur, Pseq([10]),
		\release, Pseq([10 / TempoClock.tempo]),
		\amp, 1
	).play
	// Phrase 2

}).play;)
b.play;
s.sampleRate
s.reboot