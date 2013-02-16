require_relative 'rabbit'
require_relative 'fox'
require_relative 'coordinate'

class World

	def initialize
		fieldSize = 50
		puts "Initializing world..."
		
		@grid = Hash.new(:free)
		@coordinates = []

		numfoxes = 2 + rand(3)	
		gridSize = fieldSize * fieldSize	
		range = 1..gridSize
		range = range.to_a
		foxindexes = range.sample(numfoxes)

		numrabbits = 5 + rand(10)		
		rabbittindexes = range.sample(numrabbits)

		for x in 1 ..fieldSize
			for y in 1..fieldSize
				
				coordinate = Coordinate.new(x, y)
				@coordinates << coordinate

				index = ((y - 1) * fieldSize) + x 
				
				if foxindexes.include? index
					@grid[coordinate] = Fox.new()
					next
				end

				if rabbittindexes.include? index
					@grid[coordinate] = Rabbit.new()
					next
				end
			end
		end 
		start()
	end

	def start
		pass = 0
		while pass < 100 do
			
			act
			breed
			#move
			
			draw_board()
			puts "Pass #{pass}"
			gets
			system("cls")
			#sleep(0.2)
			pass += 1
		end
	end

	private

	def act
		@coordinates.each do |coordinate|
			item = @grid[coordinate]
			
			if(item.kind_of?(Animal))
				item.sleeping = false
				item.act
				if item.dead
					item = nil
					@grid[coordinate] = :grave
				end
			end
		end
	end

	def breed
		@coordinates.each do |coordinate|
			item = @grid[coordinate]
			
			if(item.kind_of?(Animal))
				if(item.age != -1 && !item.dead)
					
					freeCoordinates = calculateFreeAdjacentLocations(coordinate)
					babies = item.breed(freeCoordinates.count)

					if (babies)
						dropCoordinates = freeCoordinates.sample(babies.count)
						dropCoordinates.each do |dropCoordinate|
					 		@grid[dropCoordinate] = babies[dropCoordinates.index(dropCoordinate)]
						end
					end
				end
			end
		end
	end

	def move
		@coordinates.each do |coordinate|
			item = @grid[coordinate]
				
			if(item.kind_of?(Animal))
				if !item.sleeping
						
					item.sleeping = true
					
					freeCoordinates = calculateFreeAdjacentLocations(coordinate)
				    if freeCoordinates.count == 0
						@grid[coordinate] = :grave
					else
						newCoordinate = item.move(freeCoordinates)
						@grid[newCoordinate] = item
						@grid[coordinate] = :used
					end
				end
			end
		end
	end

	def calculateFreeAdjacentLocations(coordinate)
		freeCoordinates = []
		for i in -1..1
   			for z in -1..1
   				unless (i == 0 && z == 0)
	   				newX = coordinate.x + i
	   				newY = coordinate.y + z

	   				if newY > 0 && newY < 51 && newX > 0 && newX < 51
	   					
	   					adjacentCoordinate = @coordinates.select { |co| co.x == newX && co.y == newY}
						item = @grid[adjacentCoordinate]

	   					unless item.kind_of?(Animal)
	   						freeCoordinates << adjacentCoordinate
	   					end
	   				end 
   				end
   			end
		end
		return freeCoordinates
	end

	def draw_board
		toDraw = ""
		@coordinates.each do |coordinate|
			
			item = @grid[coordinate]

			toDraw << "+" if (item == :grave) 
			toDraw << "." if (item == :used) 
			toDraw << "-" if (item == :free) 
			toDraw << "o" if (item == :marker)  
			
			if(item.kind_of?(Animal))
				toDraw << item.to_s 
			end

			if(coordinate.y == 50)
				toDraw << "\n"
			end
		end
		puts toDraw
	end
end