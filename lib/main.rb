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

def set_times_linear(notes, delta_b:, measure: 1, beat: 1)
  start_beat = mb_to_b(measure, beat)
  puts start_beat
  notes.each_with_index { |note, index| note.beat = start_beat + (index * delta_b) }
end

@traks = []
trak1 = create_trak
@traks << trak1

notes = 12.times.map { @kit.snare }
notes.each { |note| note.velocity = 100 }
set_times_linear(notes, delta_b: 0.25, measure: 3, beat: 2)
trak1.add_notes(notes)

@traks.each(&:recalc_delta_from_times)
# trak1.print_events

File.open("#{__dir__}/../output/1.mid", 'wb') { |file| @seq.write(file) }