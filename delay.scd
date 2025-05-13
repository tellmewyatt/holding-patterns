b = Buffer.read(s, "/home/wyatt/supercollider-projects/alto-sax/audio/delayed-section.flac")
s.options.memSize = 1024 * 200
s.options.numWireBufs = 1024
s.reboot;
({ | delayTime = 0.5 |
	var sig = PlayBuf.ar(2, b, BufRateScale.ir(b));
	var pitch = Pitch.kr(sig[0], 200, 60, 2000)[0] / 4;
	var amp = Amplitude.ar(sig);
	Saw.ar(pitch, amp)+ sig;
}.play;)