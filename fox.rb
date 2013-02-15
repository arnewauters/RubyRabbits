require_relative 'animal'
require 'win32console'
require 'colored'

class Fox < Animal
	
	def initialize
		super()
		@breedingAge = 1 + rand(1)
		@maximumAge = 2 + rand(4) + rand(4)
		@breedigProbability = 0.25
		@maxLitterSize = 4
	end

	def to_s
		x = "F"
		x.red
	end
end