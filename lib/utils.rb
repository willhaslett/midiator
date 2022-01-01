def create_trak
  trak = Midiator::Trak.new(@seq)
  @seq.tracks << trak
  trak
end

def mb_to_b(measure, beat)
  4 * (measure - 1) + beat
end

def proportion_to_7bit(proportion)
  126 * proportion + 1
end

def set_times(notes, delta_b:, measure: 1, beat: 1, exponent: 1)
  start_beat = mb_to_b(measure, beat)
  notes.each_with_index do |note, index|
    beat_from_start = start_beat + delta_b * index**exponent
    raise 'Refusing to create note after measure 1000' if beat_from_start > 4000

    note.beat = beat_from_start
  end
end

def set_velocities(notes, start_vel: 0.5, end_vel: 0.5, exponent: 1)
  delta_v = (end_vel - start_vel) / notes.count
  notes.each_with_index do |note, index|
    note.velocity = proportion_to_7bit(start_vel + delta_v * index**exponent)
  end
end
