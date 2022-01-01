require 'ostruct'
require 'pry'

require_relative 'midiator'
require_relative 'kit'

@seq = Midiator::Seq.new(bpm: 120)
@kit = Kit.new

def create_trak
  trak = Midiator::Trak.new(@seq)
  @seq.tracks << trak
  trak
end

def mb_to_b(measure, beat)
  4 * (measure - 1) + beat
end

def set_times(notes, delta_b:, measure: 1, beat: 1, exponent: 1)
  start_beat = mb_to_b(measure, beat)
  notes.each_with_index do |note, index|
    beat_from_start = start_beat + delta_b * index**exponent
    raise 'Refusing to create note after measure 1000' if beat_from_start > 4000

    note.beat = beat_from_start
  end
end

@traks = []
trak1 = create_trak
@traks << trak1

notes = 12.times.map { @kit.snare }
notes.each { |note| note.velocity = 100 }
set_times(notes, delta_b: 1, exponent: 2)
trak1.add_notes(notes)

@traks.each(&:recalc_delta_from_times)
# trak1.print_events

File.open("#{__dir__}/../output/1.mid", 'wb') { |file| @seq.write(file) }