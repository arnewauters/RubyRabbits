class Animal
	attr_reader :dead, :age
	attr_accessor:acted

	def initialize()
		@age = -1
		@dead = false
		@acted = false
	end

	def act
		@acted = true
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