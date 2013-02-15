class Animal

	attr_accessor :dead
	attr_reader :location

	def initialize(grid, location)
		@age = 0
		@dead = false
		@grid = grid
		@location = location
	end

	def act(coordinates)
		@age += 1
		@dead = true if @age > @maximumAge

		checkFood
		
		breed(coordinates) unless @dead
	end

	def move(coordinates)
		if coordinates.count > 0
		    selectedLocation = coordinates.sample

			@grid[@location[1]][@location[0]] = nil
			
			@location = selectedLocation
			@grid[selectedLocation[1]][selectedLocation[0]] = self
		else
			@dead = true
		end
	end
end