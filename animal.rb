class Animal

	attr_accessor :dead

	def initialize(locations)
		@age = 0
		@dead = false
		@locations = locations
	end

	def act

		@age += 1
		@dead = true if @age > @maximumAge

		checkFood
		
		unless @dead
			breed
			move
		end

	end

	def calculateFreeAdjacentLocations
		x, y = -1
		coordinates = Array.new()
		
		@locations.each do |location|
			if location.include? self
				y = @locations.index(location)
				x = location.index(self)

				#puts "Current location is #{x} and #{y}"

				for i in -1..1
		   			for z in -1..1
		   				unless (i == 0 && z == 0)
			   				newY = y + i
			   				newX = x + z

			   				if newY >= 0 && newY < @locations.length && newX >= 0 && newX < location.length
			   					unless @locations[newY][newX]
			   						coordinates << [newX, newY]
			   					end
			   				end 
		   				end
		   			end
				end
			end
		end

		#coordinates.each { |co| puts "#{co[0]} and #{co[1]}"  }

		return coordinates
	end
end