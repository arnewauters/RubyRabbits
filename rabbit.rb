require_relative 'animal'
require 'win32console'
require 'colored'

class Rabbit < Animal
	
	def initialize()
		
		@breedingAge = 0 + rand(1)
		@maximumAge = 20 + rand(4)
		@breedingProbability = 0.25
		@maxLitterSize = 8
		super
	end

	def checkFood
	end

	def breed(maximum)
		
		breedingFactor = rand(100)

		if(breedingFactor <= (@breedingProbability * 100))
			
			litter = rand(@maxLitterSize)
			litter = maximum if (litter > maximum)
			
			return Array.new(litter, Rabbit.new());
		end

		return nil
	end

	def to_s
		x = "R"
		x.green
	end
end