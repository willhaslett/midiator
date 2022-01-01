require_relative 'midiator'
require_relative 'project'

@seq = Project.new(Midiator::Seq.new(bpm: 120)).render
binding.pry
File.open("#{__dir__}/../output/1.mid", 'wb') { |file| @seq.write(file) }