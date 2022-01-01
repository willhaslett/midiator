require_relative 'midiator'
require_relative 'kit'
require_relative 'utils'

# foo
class Project
  def initialize(seq)
    @seq = seq
		@kit = Kit.new
  end

  def render
    @traks = []
    trak1 = create_trak
    @traks << trak1

    notes = 50.times.map { @kit.snare }
    set_times(notes, delta_b: 1, exponent: 0.6)
    set_velocities(notes, start_vel: 0.5, end_vel: 1.0)
    trak1.add_notes(notes)

    notes = 20.times.map { @kit.send(Kit::RESONATORS[rand(0..2)]) }
    set_times(notes, delta_b: 0.05, measure: 4)
    set_velocities(notes, start_vel: 1.0, end_vel: 1.0)
    trak1.add_notes(notes)

    @traks.each(&:recalc_delta_from_times)
    # trak1.print_events

    @seq
  end
end
