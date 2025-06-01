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

Pdef(\section1).play;
Pdef(\section2).play;

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
	67.wait;
	Pbind(
		\instrument, \introSwoop,
		\dur, Pseq([10]),
		\release, Pseq([10 / TempoClock.tempo]),
		\amp, 1
	).play;
	10.wait;
	// Phrase 2
	Pdef(\section2).play;

}).play;)
b.play;
s.sampleRate
s.reboot