s.options.memSize = 40 * 1024;
s.reboot;
b = Buffer.readChannel(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/reverse-creepy-vocals.wav', channels: [0])
(SynthDef(\phatBass, { | out = 0, freq = 60, gate = 1, amp = 0.2, pan=0 |
	var env = EnvGen.kr(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	var modEnv = EnvGen.kr(Env([0, 1, 0], [0.2, 1], \squared), gate);
	var sig = Saw.ar(freq + (Rand(-1, 1 ! 20)  * freq / 40), amp) + Saw.ar(freq * 2 + (Rand(-1, 1 ! 20)  * freq / 40), amp);
	sig = sig + WhiteNoise.ar(0.2);
	sig = LPF.ar(sig, 200 + (modEnv * 600));
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;)
(SynthDef(\introSwoop,{ | out = 0, amp = 1 |
	var env = EnvGen.kr(Env([0.01, 1, 0], [BufDur.ir(b) - 1, 0.01], 5 ), 1, doneAction: 2);
	var sig = PlayBuf.ar(1, b, BufRateScale.ir(b), 1) * 4;
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4 ! 10), 0);
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4));
	sig = Splay.ar(sig) * env * amp;
	Out.ar(out, sig);

}).add;
SynthDef(\ride, { |out = 0, amp = 0.2, pan = 0.5, bandFreq=400, releaseTime = 1 |
	var env = EnvGen.kr(Env.perc(0.00, releaseTime, 1, -6), 1, doneAction: 2);
	Out.ar(out, Pan2.ar(
		BPF.ar(WhiteNoise.ar(1), bandFreq, 1.0)
		, pan, amp * env))
}).add;
/*SynthDef(\bell, { | out = 0, pan = 0, amp = 0.2, freq=200, trig=1, decayTime=4 |
	var env = EnvGen.kr(Env([0, 1, 1, 0], [0, decayTime+0.1,0.1]), trig, doneAction: 2);
	var sig = Mix.ar(Ringz.ar(EnvGen.ar(Env.perc(0.01, 0.01), trig), ExpRand(freq, freq+ 2000 ! 4), decayTime, 0.1 ));
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp))
}).add;*/
)
Synth(\bell, [\freq, 1000, \amp, 0.5])
(Pdef(\section1, Ppar([
	Pbind(
		\instrument, \phatBass,
		\freq, Pseq([27, 25, 27, 25, 27].midicps),
		\dur, Pseq([25, 10, 5, 20, 2]),
		\amp, 0.2
	),
	Pbind(
		\instrument, \ride,
		\bandFreq, Pseq([
			Pseg([10000, 400], [25], \exp),
			Pseg([10000, 400], [10], \exp),
			Pseg([10000, 400], [5], \exp),
			Pseg([10000, 400], [20], \exp),
			Pseq([8000], 16)
		]),
		\releaseTime, Pseq([
			Pseg([0.1, 4], [25], \exp),
			Pseg([0.1, 4], [10], \exp),
			Pseg([0.1, 4], [5], \exp),
			Pseg([0.1, 4], [20], \exp),
			Pseq([0.05], 16)
		]),
		\dur, Pseq([
			Pseq([0.25], 60 * 4),
			Pseq([0.125], 16)
		])
	),
	Pbind(
		\instrument, \introSwoop,
		\dur, Prand([0.25, 1, 2, 10], inf)
	)
])
)
)
(
TempoClock.tempo = 132 / 60;
Task({
	Synth(\introSwoop, [\amp, 0.2]);
	6.wait;
	// Opening Phrase
	Pdef(\section1).play;
	62.wait;
	Pdef(\section1).stop;
	// Phrase 2

}).play;)

b.play;
s.sampleRate
s.reboot