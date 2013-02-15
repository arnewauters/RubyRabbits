require_relative 'animal'
require 'win32console'
require 'colored'

class Fox < Animal
	
	def initialize(locations)
		super
		@breedingAge = 1 + rand(1)
		@maximumAge = 2 + rand(4) + rand(4)
		@breedingProbability = 0.25
		@maxLitterSize = 4
		@foodlevel = 5
	end

	def checkFood
		@foodlevel -= 1
		if (@foodlevel == 0)
			@dead = true
		end
	end

	def breed
	end

	def move
	end

	def to_s
		x = "F"
		x.red
	end
end