class Animal
	attr_reader :dead

	def initialize()
		@age = -1
		@dead = false
	end

	def act
		@age += 1
		if @age > @maximumAge
			#@dead = true
		end

		checkFood
	end

	def move(coordinates)
		selectedLocation = coordinates.sample
		return selectedLocation
	end
end