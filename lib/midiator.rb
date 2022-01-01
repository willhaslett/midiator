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

    def initialize(note_params, beat_ticks, current_beat)
      note_number = BASE_NOTE_NUMBERS[note_params.pclass] + (12 * note_params.octave)
      start_beat = (note_params.measure - 1) * 4 + note_params.beat - 1
      start_tick_offset = (start_beat - current_beat) * beat_ticks * 4
      @events = [
        MIDI::NoteOn.new(0, note_number, note_params.velocity, start_tick_offset),
        MIDI::NoteOff.new(0, note_number, note_params.velocity, start_tick_offset + note_params.beats * beat_ticks)
      ]
    end
  end

  # A trak
  class Trak < MIDI::Track
    DEFAULT_VOLUME = 64

    def initialize(seq, volume: DEFAULT_VOLUME, meta: false)
      super(seq)
      return if meta

      @current_beat = 0
      @beat_ticks = seq.beat_ticks
      events << MIDI::Controller.new(0, MIDI::CC_VOLUME, volume)
    end

    def add_note(note_params)
      note_events = Note.new(note_params, @beat_ticks, @current_beat).events
      note_events.each { |event| events << event }
      @current_beat += note_params.beats
    end

    def add_notes(notes = [])
      notes.each { |note_params| add_note(note_params) }
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

    def beat_ticks
      @beat_ticks ||= note_to_delta('quarter')
    end
  end
end
