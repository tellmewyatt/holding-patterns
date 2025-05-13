b = Buffer.readChannel(s, "/home/wyatt/Documents/REAPER Media/Can Recordings/cans-combined.wav", channels: [0])
c = Buffer.readChannel(s, "/home/wyatt/Documents/REAPER Media/Can Recordings/cans-combined.wav", channels: [1])
d = Buffer.read(s, "/home/wyatt/supercollider-projects/alto-sax/audio/bell-section.flac")
(~createChannel = { | buf |
	var sig = GrainBuf.ar(1, Impulse.kr(SinOsc.kr(0.1).range(10, 40)), LFNoise2.kr(0.1).range(0, 1), buf, BufRateScale.ir(buf), SinOsc.kr(0.1)) / 2;
	var bufsig = PlayBuf.ar(1, c, 0.25, loop: 1);
	sig = sig +  bufsig + PitchShift.ar(bufsig, 0.2, 0.5);
	sig = Compander.ar(sig, sig, 0.25, 1, 0.1);
	sig;
};)
({
	[~createChannel.(b), ~createChannel.(c)];
}.play;)
(SynthDef(\score, { | out = 0, amp = 1, gate=1 |
	Out.ar(out, PlayBuf.ar(2, d, BufRateScale.ir(d), gate) * amp)
}).add;
)
(SynthDef(\canBass, { | release = 10, freq = 70, amp =  0.2 |
	var env = EnvGen.kr(Env.perc(0.001, release), doneAction: 2);
	var sig = SinOsc.ar(freq, 0, 0.2);
	sig = sig + Splay.ar(PlayBuf.ar(1, b, Rand(0.2, 3 ! 20)));
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;)
(SynthDef(\canDrum, { | attack=0.01, release = 10, freq = 70, amp =  0.2, pan = 0, scaleFactor = 0.2, scaleRange=0.4 |
	var env = EnvGen.kr(Env.perc(attack, release), doneAction: 2);
	var sig = 0;
	sig = sig + Mix.ar(PlayBuf.ar(1, b, Rand(scaleFactor, scaleFactor + scaleRange ! 4)));
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;)
(SynthDef(\canSustain, { | gate=1, freq = 70, amp =  0.2 |
	var env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.7, 1), gate, doneAction: 2);
	var fadeEnv = EnvGen.kr(Env([1, 0], [10]), gate);
	var sig = Mix.ar(Saw.ar(freq * Rand(-0.5,0.5 ! 20).midiratio, 0.2)) / 4;
	sig = sig + Splay.ar(PlayBuf.ar(1, b, Rand(freq / 1000, freq / 500 ! 20)));
	sig = sig * env * amp;
	sig = sig * fadeEnv;
	Out.ar(0, sig);
}).add;)
Synth(\canDrum, [\attack, 0.01, \release, 1, \pan, rrand(-1, 1.0), \scaleRange, 1, \scaleFactor, 0.1])
TempoClock.tempo = 120 / 60
(
var accentPattern = [
	[1, 0, 1, 0, 0, 1, 0, 0, 1, 0]!4, // 4 bars
	[1, 0]!6, // 1.5 bars
	[1, 0!4].flat, // 0.5 bars
	[1, 0, 1, 0, 0, 1, 0, 0, 1, 0]!8 // 0.5 bars
].flat;
var durs = [
	0.5!32, // 5.5 bars,
	0.4!5, // 0.5 bars,
	0.2!(20 * 4) // 4 bars
].flat;
Pbind(
	\instrument, \canDrum,
	\attack, 0.01,
	\release, 1,
	\pan, Pwhite(-1, 1.0),
	\scaleRange, Pseq(
		accentPattern.replace(1, 0.1).replace(0, 1)
	),
	\amp, Pseq(
		accentPattern.replace(1, 0.2).replace(0, 0.1)
	),
	\scaleFactor, Pseq([
		Pseg([0.1, 2], 16),
		Pseg([3, 2], 2),
		Pseg([3, 1], 1, \lin, 20)
	]),
	\dur, Pseq(durs)
).play;
Pbind(
	\instrument, \canBass,
	\freq, Pseq([70, 90, 120, 100 ]),
	\dur, Pseq([5, 5, 4, 4, 4]),
).play;
Pbind(
	\instrument, \score,
	\dur, 2000,
	\amp, 0.5
).play;

)
Synth(\canSustain)
TempoClock.tempo = 1
(
~midi = SimpleMIDIFile.read("/home/wyatt/supercollider-projects/alto-sax/audio/middle-section.mid");
)
d = Buffer.read(s, "/home/wyatt/supercollider-projects/alto-sax/audio/middle-section-Alto_Saxophone.flac");
(
~midi.p(\canSustain).play;
d.play;
)
TempoClock.tempo = 1