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
    @piano_trak = Midiator::Trak.new(@seq)
    @traks = [
      @piano_trak
    ]
  end

  def create_notes
    create_kit_notes
    create_piano_notes
  end

  def create_piano_notes
    notes = 40.times.map { @piano.note(octave: 4, pclass: :e) }
  end

  def create_kit_notes; end

  def render
    @traks.each(&:recalc_delta_from_times)
    @seq
  end
end
