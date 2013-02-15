require_relative 'animal'
require 'win32console'
require 'colored'

class Rabbit < Animal
	
	def initialize
		super()
		@breedingAge = 0 + rand(1)
		@maximumAge = 8 + rand(4)
		@breedigProbability = 0.25
		@maxLitterSize = 8
	end

	def to_s
		x = "R"
		x.green
	end
end