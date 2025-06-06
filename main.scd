s.options.memSize = 80 * 1024;
~main = Task({
	TempoClock.tempo = 132 / 60;
	// Opening Phrase
	Pdef(\section1).play;
	70.wait;
	Pdef(\section1).stop;
	// Phrase 2
	Pdef(\section2).play;

});
s.waitForBoot {
	TempoClock.tempo = 132 / 60;
	// Load all the buffers and execute the file
	Routine {
		~buffers = (
			creepyVocals: Buffer.readChannel(s, "audio/creepy-vocals.wav".resolveRelative, channels: [0]),
			score: Buffer.read(s, PathName(thisProcess.nowExecutingPath).pathOnly +/+ './audio/score.wav'),
			cansLeft: Buffer.readChannel(s, "/home/wyatt/Documents/REAPER Media/Can Recordings/cans-combined.wav", channels: [0]),
			cansRight: Buffer.readChannel(s, "/home/wyatt/Documents/REAPER Media/Can Recordings/cans-combined.wav", channels: [1])
		);
		this.executeFile("synthdefs.scd".resolveRelative);
		this.executeFile("section1.scd".resolveRelative);
		this.executeFile("section2.scd".resolveRelative);
		s.sync;
		~main.play;
	}.play;
}
