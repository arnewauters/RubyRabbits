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
					coordinate2 = Coordinate.new(x, y)
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
			move
			
			draw_board()
			
			puts "Pass #{pass}"
			sleep(0.5)
			system("cls")
			
			pass += 1
		end
	end

	private

	def act
		@coordinates.each do |coordinate|
			item = @grid[coordinate]
			
			if item.kind_of?(Animal)
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
					
					freeCoordinates = @coordinates.select { |co|
					 	dx = (coordinate.x - co.x).abs
					 	dy = (coordinate.y - co.y).abs

					 	(dx + dy == 1)
					}

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

			if item.kind_of?(Animal)

				if !item.sleeping
					
					item.sleeping = true
					
					freeCoordinates = @coordinates.select { |co|
					 	dx = (coordinate.x - co.x).abs
					 	dy = (coordinate.y - co.y).abs

					 	(dx + dy == 1)
					}

				    if freeCoordinates.count == 0
						@grid[coordinate] = :grave
					else

						newCoordinate = freeCoordinates.sample
						@grid[newCoordinate] = item
						@grid[coordinate] = :used
					end
				end
			end
		end
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