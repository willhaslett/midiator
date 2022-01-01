require 'pry'

require_relative 'lib/midiator'

@seq = Midiator::Seq.new

def create_trak
  trak = Midiator::Trak.new(@seq)
  @seq.tracks << trak
  trak
end

trak1 = create_trak

trak1.add_notes(
  [
    Midiator::NoteParams.new(
      pclass: :f,
      octave: 3,
      velocity: 99,
      measure: 1,
      beat: 1,
      beats: 3
    ),
    Midiator::NoteParams.new(
      pclass: :d,
      octave: 1,
      velocity: 112,
      measure: 1,
      beat: 1,
      beats: 6
    )
  ]
)

File.open('./output/1.mid', 'wb') { |file| @seq.write(file) }
