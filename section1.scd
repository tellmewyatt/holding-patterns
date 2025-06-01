Pdef(\section1,
	Pseq([
		Ppar([
			Pbind(
				\instrument, \introSwoop,
				\bufnum, ~buffers.creepyVocals,
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
				\bufnum, ~buffers.score,
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
				\bufnum, ~buffers.creepyVocals,
				\dur, Prand([0.25, 1, 2, 10], inf)
			)
		])
	])
)