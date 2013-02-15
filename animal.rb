class Animal
	attr_reader :dead

	def initialize()
		@age = 0
		@dead = false
	end

	def act
		@age += 1
		if @age > @maximumAge
			@dead = true
		end

		checkFood
	end

	def move(coordinates)
		if coordinates.count > 0
		    selectedLocation = coordinates.sample
			return selectedLocation
		end
		
		@dead = true
		return nil
	end
end