class Animal
	attr_reader :dead, :age

	def initialize()
		@age = -1
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
		selectedLocation = coordinates.sample
		return selectedLocation
	end

	def  kill
		@dead = true
	end
end