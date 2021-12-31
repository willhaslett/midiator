# The Midiator module
module Midiator
  require 'midilib/sequence'
  require 'midilib/consts'
  include MIDI

  # A trak
  class Trak < ::MIDI::Track
    DEFAULT_VOLUME = 64

    def initialize(seq, volume: DEFAULT_VOLUME, meta: false)
      super(seq)
      return if meta

      events << MIDI::Controller.new(0, MIDI::CC_VOLUME, volume)
    end
  end

  # A region
  class Region
    attr_accessor :trak, :start_beat, :duration, :events

    def initialize(trak, start_beat, duration)
      @trak = trak
      @start_beat = start_beat
      @duration = duration
      @events = []
    end
  end

  # A sequence
  class Seq < ::MIDI::Sequence
    DEFAULT_BPM = 85

    attr_accessor :metadata, :tracks

    def initialize(metadata = {})
      super()
      @metadata = metadata
      @tempo_trak = Trak.new(self, meta: true)
      @tracks << @tempo_trak
      @tempo_trak.events << ::MIDI::Tempo.new(::MIDI::Tempo.bpm_to_mpq(metadata[:bpm] || DEFAULT_BPM))
      @instruments = []
    end

    def beat
      @beat ||= note_to_delta('quarter')
    end
  end
end
