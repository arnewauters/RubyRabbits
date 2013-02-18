require_relative 'animal'
require 'win32console'
require 'colored'

class Rabbit < Animal
	
	def initialize()
		
		@breedingAge = 1 + rand(1)
		@maximumAge = 8 + rand(4)
		@breedingProbability = 0.7
		@maxLitterSize = 6
		super
	end

	def checkFood
	end

	def breed(maximum)
		
		if (maximum == 0 || @age < @breedingAge)
			return nil
		end

		breedingFactor = rand(100)

		if(breedingFactor <= (@breedingProbability * 100))
			
			litter = 2 + rand(@maxLitterSize)
			litter = maximum if (litter > maximum)
			
			return Array.new(litter, Rabbit.new());
		else
			return nil
		end	
	end

	def to_s
		return "R"

		# if (age < 1)
		# 	x.yellow
		# else
		# 	x.green
		# end
	end
end