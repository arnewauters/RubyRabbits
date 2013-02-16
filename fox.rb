require_relative 'animal'
require 'win32console'
require 'colored'

class Fox < Animal
	
	def initialize()
		@breedingAge = 1 + rand(1)
		@maximumAge = 2 + rand(4) + rand(4)
		@breedingProbability = 0.25
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
		
		if @age >= @breedingAge
			return Array.new(7, Fox.new());
		end

		return nil

		# breedingFactor = rand(100)

		# if(breedingFactor <= (@breedingProbability * 100))
			
		# 	litter = rand(@maxLitterSize)
		# 	litter = maximum if (litter > maximum)
			
		# 	return Array.new(litter, Fox.new());
		# end

		# return nil
	end

	def to_s
		x = "F"
		x.red
	end
end