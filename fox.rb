require_relative 'animal'
require 'win32console'
require 'colored'

class Fox < Animal
	
	def initialize()
		@breedingAge = 1
		@maximumAge = 8
		@breedingProbability = 0.5
		@maxLitterSize = 3
		@foodlevel = 6

		super
	end

	def checkFood
		@foodlevel -= 1

		if (@foodlevel == 0)
			@dead = true
		end
	end

	def eat(rabbit)
		@foodlevel += 6
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
		return "F"
		# if (age < 1)
		# 	x.blue
		# else
		# 	x.red
		# end
	end
end