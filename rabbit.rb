require_relative 'animal'
require 'win32console'
require 'colored'

class Rabbit < Animal
	
	def initialize(grid, location)
		super
		@breedingAge = 0 + rand(1)
		@maximumAge = 8 + rand(4)
		@breedingProbability = 0.25
		@maxLitterSize = 8
	end

	def checkFood
	end

	def breed(coordinates)
		breedingFactor = rand(100)

		if(breedingFactor <= (@breedingProbability * 100))
			
			litter = rand(@maxLitterSize)
			litter = coordinates.count if (litter > coordinates.count)
			selectedLocations = coordinates.sample(litter)

			selectedLocations.each do |loc|
				@grid[loc[1]][loc[0]] = Rabbit.new(@grid, loc)
			end
		end
	end

	def to_s
		x = "R"
		x.green
	end
end