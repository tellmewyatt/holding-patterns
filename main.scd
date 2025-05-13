(~mapMidiToSynth = { | synthdef, channel |
	var poly = ();
	MIDIdef.noteOn(synthdef ++ '-noteOn', { | vel, noteNum |
		poly.at(noteNum).isPlaying.if({
			poly.at(noteNum).release;
		});
		poly[noteNum] = Synth(synthdef, [\freq, noteNum.midicps, \amp, vel / 127.0]).register();
	});
	MIDIdef.noteOff(synthdef ++ '-noteOff', { | vel, noteNum |
		poly.postln;
		poly.at(noteNum).postln;
		poly.at(noteNum).release;
	});
})

}
MIDI
~mapMidiToSynth.(\canSustain)

MIDIFunc
MIDIClient.init
MIDIIn.connectAll
MIDIIn.doNoteOnAction(1, 1, 64, 64); // spoof a note on
MIDIIn.doNoteOffAction(1, 1, 64, 64);
MIDIdef.all