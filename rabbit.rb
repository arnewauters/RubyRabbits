require_relative 'animal'
require 'win32console'
require 'colored'

class Rabbit < Animal
	
	def initialize(locations)
		super
		@breedingAge = 0 + rand(1)
		@maximumAge = 8 + rand(4)
		@breedingProbability = 0.25
		@maxLitterSize = 8
	end

	def checkFood
	end

	def breed
		breedingFactor = rand(100)

		if(breedingFactor <= (@breedingProbability * 100))
			
			possibleDropLocations = calculateFreeAdjacentLocations
			litter = rand(@maxLitterSize)
			litter = possibleDropLocations.count if (litter > possibleDropLocations.count)
			selectedLocations = possibleDropLocations.sample(litter)

			selectedLocations.each do |loc|
				@locations[loc[1]][loc[0]] = Rabbit.new(@locations)
			end
		end
	end

	def move
	end

	def to_s
		x = "R"
		x.green
	end
end