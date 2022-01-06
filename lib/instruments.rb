require_relative 'midiator'

# For all instruments, caller is responsible for these after instiantiation:
#   velocity
#   measure
#   beat

# Inst
class Inst
  def note(octave: 3, pclass: :c, beats: 1)
    Midiator::NoteParams.new(octave: octave, pclass: pclass, beats: beats)
  end
end

# Kit
class Kit
  RESONATORS = [
    :kick,
    :snare,
    :closed_hh
  ]

  def initialize
    @kick = { octave: 1, pclass: :c }
    @snare = { octave: 1, pclass: :d }
    @closed_hh = { octave: 1, pclass: :fs }
    @params = { beats: 0.25 }
  end

  def note(resonator)
    @params.merge!(resonator)
    Midiator::NoteParams.new(**@params)
  end

  def kick
    note(@kick)
  end

  def snare
    note(@snare)
  end

  def closed_hh
    note(@closed_hh)
  end
end
