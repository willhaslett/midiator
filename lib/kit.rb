require_relative 'midiator'

# Caller is responsible for:
#   velocity
#   measure
#   beat
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
