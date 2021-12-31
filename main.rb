require_relative 'lib/midiator'

@seq = Midiator::Seq.new

def create_trak
  trak = Midiator::Trak.new(@seq)
  @seq.tracks << trak
  trak
end

def create_events(track)
  Random.rand(4..8).times.map { Random.rand(1..12) }.each do |pitch_class|
    track.events << MIDI::NoteOn.new(0, 64 + pitch_class, 127, 0)
    track.events << MIDI::NoteOff.new(0, 64 + pitch_class, 127, @seq.beat)
  end
end

track1 = create_trak
create_events(track1)

track2 = create_trak
create_events(track2)

File.open('./output/1.mid', 'wb') { |file| @seq.write(file) }
