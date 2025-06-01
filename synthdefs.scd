SynthDef(\score, { | out = 0, trig = 1, amp = 1, bufnum |
	Out.ar(out, PlayBuf.ar(2, bufnum, BufRateScale.ir(bufnum), trig, doneAction: 2) * amp)
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
SynthDef(\introSwoop,{ | out = 0, amp = 1, release=1, trig=1, freq, bufnum |
	var env = EnvGen.kr(Env([0.01, 1, 0], [release, 0], 5 ), 1, doneAction: 2);
	var sig = PlayBuf.ar(1, bufnum, BufRateScale.ir(bufnum), trig) * 4;
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4 ! 10), 0);
	sig = PitchShift.ar(sig, 0.2, Rand(0.5, 4));
	sig = Splay.ar(sig) * env * amp;
	Out.ar(out, sig);

}).add;
SynthDef(\introSustain,{ | out = 0, amp = 0.2, gate=1, freq=400, combAmount=0, bufnum |
	var env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
	var sig = PlayBuf.ar(1, bufnum, BufRateScale.ir(bufnum), gate, loop: 1) * 4;
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
	Out.ar(out, Pan2.ar(sig, pan, amp * env))
}).add;
SynthDef(\cansBackground, { | out = 0, bufnums = #[4,5], cutoff = 100 |
	var sig = bufnums.collect { | bufnum |
		var sig = GrainBuf.ar(1,
			Impulse.kr(SinOsc.kr(0.1).range(10, 40)), // triggger
			LFNoise2.kr(0.1).range(0, 1), // dur
			bufnum, // sig
			BufRateScale.ir(bufnum), // rate
			SinOsc.kr(0.1)
		) / 2;
		var bufsig = PlayBuf.ar(1, bufnum, 0.25, loop: 1);
		sig = sig +  bufsig + PitchShift.ar(bufsig, 0.2, 0.5);
		sig = Compander.ar(sig, sig, 0.25, 1, 0.1);
		sig = LPF.ar(sig, cutoff);
	};
	Out.ar(out, sig);
}).add;
SynthDef(\canBass, { | dur, freq = 70, amp =  0.2, bufnum |
	var env = EnvGen.kr(Env.perc(0.001, dur), doneAction: 2);
	var sig = SinOsc.ar(freq, 0, 0.2);
	sig = sig + Splay.ar(PlayBuf.ar(1, bufnum, Rand(0.2, 3 ! 20) * BufRateScale.ir(bufnum)));
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
SynthDef(\canDrum, { | attack=0.01, release = 10, freq = 70, amp =  0.2, pan = 0, scaleFactor = 0.2, scaleRange=0.4, bufnum |
	var env = EnvGen.kr(Env.perc(attack, release), doneAction: 2);
	var sig = 0;
	sig = sig + Mix.ar(
		PlayBuf.ar(1, bufnum, Rand(scaleFactor, scaleFactor + scaleRange ! 4) * BufRateScale.ir(bufnum)));
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
SynthDef(\canSustain, { | gate=1, freq = 70, amp =  0.2, bufnum |
	var env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.7, 1), gate, doneAction: 2);
	var fadeEnv = EnvGen.kr(Env([1, 0], [10]), gate);
	var sig = Mix.ar(Saw.ar(freq * Rand(-0.5,0.5 ! 20).midiratio, 0.2)) / 8;
	sig = sig + Splay.ar(PlayBuf.ar(1, bufnum, Rand(freq / 1000, freq / 500 ! 20) * BufRateScale.ir(bufnum)));
	sig = sig * env * amp;
	sig = sig * fadeEnv;
	Out.ar(0, sig);
}).add;
SynthDef(\kick, { | out = 0, amp = 0.2, pan = 0,spreadSemitones=4, release=0.5, freq=80 |
	var env = EnvGen.ar(Env.perc(0.001, 1), doneAction: 2);
	var sig = Mix.ar(SinOsc.ar(freq * Rand(0-spreadSemitones, spreadSemitones ! 20).midiratio) /6) * env;
	sig = Limiter.ar(sig, 0.9);
	Out.ar(out,
		Pan2.ar(sig, pan, amp));
}).add;