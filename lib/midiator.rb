# The Midiator module
module Midiator
  require 'midilib/sequence'
  require 'midilib/consts'
  include MIDI

  # Params needed to create a Note
  class NoteParams
    attr_accessor :pclass, :octave, :velocity, :measure, :beat, :beats

    def initialize(
      pclass: :c,
      octave: 0,
      velocity: 0,
      measure: 1,
      beat: 1,
      beats: 0
    )
      @pclass = pclass
      @octave = octave
      @velocity = velocity
      @measure = measure
      @beat = beat
      @beats = beats
    end
  end

  # A note
  class Note
    attr_accessor :events

    BASE_NOTE_NUMBERS = {
      a: 21,
      bb: 22,
      b: 23,
      c: 24,
      cs: 25,
      d: 26,
      eb: 27,
      e: 28,
      f: 29,
      fs: 30,
      g: 31,
      ab: 32
    }

    def initialize(note_params, beat_ticks)
      note_number = BASE_NOTE_NUMBERS[note_params.pclass] + (12 * note_params.octave)
      start_tick = ((4 * (note_params.measure - 1) + note_params.beat - 1) * beat_ticks).round
      duration_ticks = (note_params.beats * beat_ticks).round
      @events = [

        MIDI::NoteOn.new(0, note_number, note_params.velocity, 0, start_tick),
        MIDI::NoteOff.new(0, note_number, note_params.velocity, 0, start_tick + duration_ticks)

        # MIDI::NoteOn.new(0, note_number, note_params.velocity, start_tick, 0),
        # MIDI::NoteOff.new(0, note_number, note_params.velocity, start_tick + duration_ticks, 0)
      ]
    end
  end

  # A trak
  class Trak < MIDI::Track
    DEFAULT_VOLUME = 64

    def initialize(seq, volume: DEFAULT_VOLUME, meta: false)
      super(seq)
      return if meta

      @beat_ticks = seq.beat_ticks
      events << MIDI::Controller.new(0, MIDI::CC_VOLUME, volume)
    end

    def add_note(note_params)
      note_events = Note.new(note_params, @beat_ticks).events
      note_events.each { |event| events << event }
    end

    def add_notes(notes = [])
      notes.each { |note_params| add_note(note_params) }
      print_events
      recalc_delta_from_times
    end

    def add_rest(beats)
      note_params = NoteParams.new(beats: beats)
      events << Note.new(note_params)
    end
  end

  # A sequence
  class Seq < MIDI::Sequence
    DEFAULT_BPM = 85

    attr_accessor :metadata, :tracks

    def initialize(bpm: 85)
      super()
      @bpm = bpm
      @tempo_trak = Trak.new(self, meta: true)
      @tracks << @tempo_trak
      @tempo_trak.events << ::MIDI::Tempo.new(::MIDI::Tempo.bpm_to_mpq(@bpm))
    end

    # It's just 480
    def beat_ticks
      @beat_ticks ||= note_to_delta('quarter')
    end
  end
end
