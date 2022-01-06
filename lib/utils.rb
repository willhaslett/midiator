include Math

def mb_to_b(measure, beat)
  4 * (measure - 1) + beat
end

def proportion_to_7bit(proportion)
  127 * proportion
end

# param is a symbol
def set_param(notes, param, value)
  notes.map { |note| note.send("#{param}=", value) }
end

def set_times(notes, delta_b:, measure: 1, beat: 1)
  start_beat = mb_to_b(measure, beat)
  notes.each_with_index do |note, index|
    beat_from_start = start_beat + delta_b * index
    note.beat = beat_from_start
  end
end

# `start` and `end` are floats 0.0 <= x <= 1.0
# Applies a linear tranformation to the passed-in param for the passed-in notes from floats to 7-bit
# `param` is a symbol, the method to be called on each note
def linear(notes, param, start_val: 0.5, end_val: 0.5)
  delta_v = (end_val - start_val) / notes.count
  notes.each_with_index do |note, index|
    note.send("#{param}=", proportion_to_7bit(start_vel + delta_v * index))
  end
end

def deg_to_rad(deg)
  deg * Math::PI / 180
end

# Apply a harmonic function to a parameter for a set of Notes. Defaults to 1/2 cosine low-to-hi
#
# y = (amplitude * sin((x + phase)/cycles) + y_offset)
# values are scaled to 0-127 and applied to `param` over the array of notes
# @param [Array] :notes the Notes to apply a harmonic function to
# @param [Symbol] :param the Note property/method to apply the function to for each note
# @param [Integer] :phase the angle, 0-360, at which to start the transformation
# @param [Float] :amplitude, the midline-to-peak amplitude, 0.0-1.0 of the function, which is scaled to 0-63
# @param [Float] :y_offset, shift up y-axis for all values, not to exceed 1/4 * amplitude
# @param [Float] :cycles, the number of harmonic cycles to apply, 1.0 will apply 2 * pi radians 
def harmonic(notes, param, phase: -90, amplitude: 0.5, y_offset: 0.5, cycles: 0.5)
  radians_per_note = ((2 * Math::PI) / (notes.count - 1)) * cycles
  notes.each_with_index do |note, i|
    angle = i * radians_per_note
    y = amplitude * sin(angle + deg_to_rad(phase)) + y_offset
    puts proportion_to_7bit(y)
    note.send("#{param}=", proportion_to_7bit(y))
  end
  nil
end

# y = A sin(B(x + C)) + D
#     amplitude is A
#     period is 2π/B
#     phase shift is C (positive is to the left)
#     vertical shift is D
