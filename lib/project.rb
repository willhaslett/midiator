require 'pry'
require_relative 'midiator'
require_relative 'instruments'
require_relative 'utils'

# foo
class Project
  def initialize(seq)
    @seq = seq
    create_instruments
    create_traks
    create_notes
  end

  def create_instruments
    @kit = Kit.new
    @piano = Inst.new
  end

  def create_traks
    @kit_trak = Midiator::Trak.new(@seq)
    @piano_trak = Midiator::Trak.new(@seq)
    @traks = [
      @kit_trak,
      @piano_trak
    ]
    @traks.each { |trak| @seq.tracks << trak }
  end

  def create_notes
    create_kit_notes
    create_piano_notes
  end

  def create_kit_notes
    notes = 2.times.map { @kit.snare }
    set_times(notes, delta_b: 1, exponent: 0.6)
    set_velocities(notes, start_vel: 0.5, end_vel: 1.0)
    @kit_trak.add_notes(notes)
  end

  def create_piano_notes
    notes = 4.times.map { @piano.note(octave: 2, pclass: :e, beats: 1) }
    set_times(notes, delta_b: 2, measure: 1)
    set_velocities(notes, start_vel: 1.0, end_vel: 1.0)
    @piano_trak.add_notes(notes)
  end

  def render
    @traks.each do |trak|
      trak.recalc_delta_from_times
    end
    @seq
  end
end
