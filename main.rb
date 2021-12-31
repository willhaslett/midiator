require 'midilib/sequence'
require 'midilib/consts'
include MIDI

seq = Sequence.new
meta_track = Track.new(seq)
seq.tracks << meta_track
meta_track.events << Tempo.new(Tempo.bpm_to_mpq(85))
QUARTER = seq.note_to_delta('quarter')

def create_track(seq, vol=64)
  track = Track.new(seq)
  seq.tracks << track
  track.events << Controller.new(0, CC_VOLUME, vol)
  track
end

def create_events(track)
  Random.rand(4..8).times.map{ Random.rand(1..12) }.each do |pitch_class|
    track.events << NoteOn.new(0, 64 + pitch_class, 127, 0)
    track.events << NoteOff.new(0, 64 + pitch_class, 127, QUARTER)
  end
end

create_events(create_track(seq))
create_events(create_track(seq))

File.open('./output/1.mid', 'wb') { |file| seq.write(file) }

# track.recalc_times