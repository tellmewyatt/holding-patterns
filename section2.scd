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
//Pbind(\instrument, \score, \dur, 2000, \amp, 0.5).play;
Pdef(\section2, Pseq([
	Ppar([
		Pbind(
			\instrument, \canDrum,
			\bufnum, ~buffers.cansLeft,
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
		),
		Pbind(
			\instrument, \canBass,
			\bufnum, ~buffers.cansLeft,
			\freq, Pseq([70, 90, 120, 100 ]),
			\dur, Pseq([5, 5, 4, 4, 4]),
		)
	]),
	Ppar([
		Pbind(
			\instrument, \canDrum,
			\bufnum, ~buffers.cansLeft,
			\attack, 0.01,
			\release, 1,
			\pan, Pseg(
				[-1, 1, -1, 1],
				[15, 20, 10]),
			\amp, 0.2,
			\scaleFactor, Pseq([
				Pseg([0.1, 2], 9 * 5)
			]),
			\dur, Pseq([
				Pseq([1,1,1,1,0.2!5].flat, 3),
				Pseq([0.5!8,0.2!5].flat, 4),
				Pseq([0.25!16,0.2!5].flat, 1),
				Pseq([0.125!40].flat, 1)
			])
		),
		Pbind(
			\instrument, \kick,
			\dur, Pseq([
				Pseq([5], 3),
				Pseq([[1.5, 0.5]!2, 1].flat, 4),
				Pseq(1!5, 2)
			]),
			\freq, 100,
			\amp, 0.2,
			\release, 0.4
		)
	]),
	Pbind(
		\instrument, \introSwoop,
		\bufnum, ~buffers.creepyVocals,
		\dur, Pseq([3,2], 4),
		\release, Pseq([2 / TempoClock.tempo, ], 8),
		\freq, Pseq([\rest, 40], 4),
		\amp, 1
	)
])
)