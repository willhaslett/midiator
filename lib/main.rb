require 'pry'

require_relative 'midiator'

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
      pclass: :d,
      octave: 1,
      velocity: 112,
      measure: 1,
      beat: 1,
      beats: 1
    ),
    Midiator::NoteParams.new(
      pclass: :f,
      octave: 3,
      velocity: 99,
      measure: 2,
      beat: 3,
      beats: 7
    ),
    Midiator::NoteParams.new(
      pclass: :d,
      octave: 3,
      velocity: 99,
      measure: 2,
      beat: 3.7,
      beats: 2
    ),
  ]
)

File.open("#{__dir__}/../output/1.mid", 'wb') { |file| @seq.write(file) }
