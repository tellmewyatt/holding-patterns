s.options.memSize = 40 * 1024;
~main = Task({
	TempoClock.tempo = 132 / 60;
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

});
s.waitForBoot {
	// Load all the buffers and execute the file
	Routine {
		~buffers = (
			creepyVocals: Buffer.readChannel(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/creepy-vocals.wav', channels: [0]),
			score: Buffer.read(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/score.wav'),
			cansLeft: Buffer.readChannel(s, "/home/wyatt/Documents/REAPER Media/Can Recordings/cans-combined.wav", channels: [0]),
			cansRight: Buffer.readChannel(s, "/home/wyatt/Documents/REAPER Media/Can Recordings/cans-combined.wav", channels: [1])
		);
		s.sync;
		this.executeFile("synthdefs.scd".resolveRelative);
		this.executeFile("section1.scd".resolveRelative);
		~main.play;
	}.play;
}
x = Synth(\cansBackground, [\bufnums, [~buffers.cansLeft, ~buffers.cansRight]])
x.set(\cutoff, 3000)
x.release;