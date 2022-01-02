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
      # @kit_trak,
      @piano_trak
    ]
    @traks.each { |trak| @seq.tracks << trak }
  end

  def create_notes
    create_kit_notes
    create_piano_notes
  end

  def create_piano_notes
    notes = 800.times.map { @piano.note(octave: 4, pclass: :e) }
    time_sweep(
      notes,
      delta_b: 0.0125,
      coef_2nd: 5,
      note_duration_proportion: 0.9
    )
    set_velocity(notes, 50)
    @piano_trak.add_notes(notes)
  end

  def create_kit_notes; end

  def render
    @traks.each(&:recalc_delta_from_times)
    @seq
  end
end
