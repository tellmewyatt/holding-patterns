(
~effectsBus = Bus.audio(s, 1);
)
(
var score = Buffer.read(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/score.flac');
SynthDef(\score, { | out = 0, trig = 1, amp = 1, startPos=0.5 |
	Out.ar(out, PlayBuf.ar(2, score, BufRateScale.ir(score), trig, startPos * BufFrames.ir(score), doneAction: 2) * amp)
}).add;)
(
SynthDef(\pitchShift, { | in, out = 0 |
	var shiftWidth = 1;
	var sig =  In.ar(in, 1);
	sig = Splay.ar([sig,
		PitchShift.ar(sig, shiftWidth, 2),
		PitchShift.ar(sig, shiftWidth, 0.5),
		PitchShift.ar(sig, shiftWidth, 0.25),
		PitchShift.ar(sig, shiftWidth, 3.midiratio),
		PitchShift.ar(sig, shiftWidth, 7.midiratio),
		PitchShift.ar(sig, shiftWidth, 10.midiratio)
	].scramble);
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\superSaw, { | out = 0, amp = 0.2, freq=440, gate=1 |
	var env = EnvGen.kr(Env.adsr(0.01, 0.1, 0.9), gate, doneAction: 2);
	var sig = Saw.ar(freq * Rand((-0.5).midiratio, (0.5).midiratio ! 20)) * amp * 0.5;
	sig = Splay.ar(sig) * env;
	Out.ar(out, sig);
}).add;

)
Synth(\score, [\startPos, 0.55, \out, ~effectsBus], addAction: \addToHead)
Synth(\pitchShift, [\in, ~effectsBus], addAction: \addToTail)
3.midiratio

x = Synth(\superSaw, [\freq, (63-24).midicps])
(
x.release;
x=Synth(\superSaw, [\freq, (65-24).midicps])
)
(
x.release;
x=Synth(\superSaw, [\freq, (66-24).midicps])
)
(
x.release;
x=Synth(\superSaw, [\freq, (67-24).midicps])
)
x.release;
