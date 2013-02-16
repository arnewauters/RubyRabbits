require_relative 'animal'
require 'win32console'
require 'colored'

class Fox < Animal
	
	def initialize()
		@breedingAge = 1
		@maximumAge = 3
		@breedingProbability = 0.4
		@maxLitterSize = 6
		@foodlevel = 5

		super
	end

	def checkFood
		if (@foodlevel == 0)
		@foodlevel -= 1
			#@dead = true
		end
	end

	def breed(maximum)
		
		if (maximum == 0 || @age < @breedingAge)
			return nil
		end

		breedingFactor = rand(100)

		if(breedingFactor <= (@breedingProbability * 100))
			
			litter = rand(@maxLitterSize)
			litter = maximum if (litter > maximum)
			
			return Array.new(litter, Fox.new());
		else
			return nil
		end	
	end

	def to_s
		x = "F"
		if (age < 1)
			x.blue
		else
			x.red
		end
	end
end