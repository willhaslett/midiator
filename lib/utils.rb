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

def time_sweep(
  notes,
  delta_b:,
  measure: 1,
  beat: 1,
  coef_2nd: 0,
  coef_3rd: 0,
  note_duration_proportion: 1.0
)
  start_beat = mb_to_b(measure, beat)
  notes.each_with_index do |note, index|
    beat_offset = polynomial(index * delta_b, coef_2nd, coef_3rd)
    beat_offset_next = polynomial((index + 1) * delta_b, coef_2nd, coef_3rd)
    note.beat = start_beat + beat_offset
    note.beats = (beat_offset_next - beat_offset) * note_duration_proportion
    # puts "beat_offset: #{beat_offset} beat_offset_next: #{beat_offset_next} beat: #{start_beat + beat_offset} beats: #{(beat_offset_next - beat_offset) * note_duration_proportion}"
  end
end

def polynomial(x, coef_2nd, coef_3rd)
  x + (coef_2nd * x**2) + (coef_3rd * x**3)
end

def set_velocity(notes, velocity)
  notes.map { |note| note.velocity = velocity }
end

def velocity_sweep(notes, start_vel: 0.5, end_vel: 0.5, exponent: 1)
  delta_v = (end_vel - start_vel) / notes.count
  notes.each_with_index do |note, index|
    note.velocity = proportion_to_7bit(start_vel + delta_v * index**exponent)
  end
end
