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

# param is a symbol
def set_param(notes, param, value)
  notes.map { |note| note.send("#{param}=", value) }
end

# `start` and `end` are floats 0.0 <= x <= 1.0
# Applies a linear tranformation to the passed-in param for the passed-in notes to 7-bit
# `param` is a symbol == the method to be called on each note
def linear_sweep(notes, param, start_val: 0.5, end_val: 0.5)
  delta_v = (end_val - start_val) / notes.count
  notes.each_with_index do |note, index|
    note.send("#{param}=", proportion_to_7bit(start_vel + delta_v * index))
  end
end