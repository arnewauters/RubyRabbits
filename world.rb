require_relative 'rabbit'
require_relative 'fox'

class World

	def initialize
		fieldSize = 50

		puts "Initializing world..."
		@grid = Array.new(fieldSize) { Array.new(fieldSize, nil) }

		puts "Breeding random number of foxes between 2 and 5..."
		
		numfoxes = 2 + rand(3)

		for i in 0..numfoxes
			notAssigned = true

			while notAssigned
				x = rand(fieldSize)
				y = rand(fieldSize)

				unless @grid[x][y] 
					@grid[x][y] = Fox.new(@grid, [x, y])
					notAssigned = false
				end
			end
			i += 1
		end
		puts "Breeded and deployed #{numfoxes} foxes..."
		
		puts "Breeding random number of rabbits between 5 and 25..."

		numrabbits = 5 + rand(20)

		for z in 0..numrabbits
			notAssigned = true

			while notAssigned
				x = rand(fieldSize)
				y = rand(fieldSize)

				unless @grid[x][y] 
					@grid[x][y] = Rabbit.new(@grid, [x, y])
					notAssigned = false
					#puts "Assigned rabbit to x: #{x} and y: #{y}"
				end
			end
			z += 1
		end
		
		puts "Breeded and deployed #{numrabbits} rabbits..."

		puts "Starting simulation sequence in 5 seconds!"
		sleep(5)
		system("cls")

		start()
	end

	def start
		
		i = 0
		while i < 25 do
			
			allSpots = @grid.flatten
			
			allSpots.each do |spot| 
				if spot
					
					coordinates = calculateFreeAdjacentLocations(spot)
					spot.act(coordinates)
					
					if spot.dead
						@grid[spot.location[1]][spot.location[0]] = nil
					else
						coordinates = calculateFreeAdjacentLocations(spot)
						spot.move(coordinates)
					end
				end
			end

			sleep(0.5)
			system("cls")
			draw_board()
			puts "Pass #{i}"

			i += 1
		end
	end

	private

	def calculateFreeAdjacentLocations(animal)
		x, y = -1
		coordinates = Array.new()
		
		@grid.each do |gridRow|
			for i in -1..1
	   			for z in -1..1
	   				unless (i == 0 && z == 0)

		   				newY = animal.location[1] + i
		   				newX = animal.location[0] + z

		   				if newY >= 0 && newY < @grid.length && newX >= 0 && newX < gridRow.length
		   					unless @grid[newY][newX]
		   						coordinates << [newX, newY]
		   					end
		   				end 
	   				end
	   			end
			end
		end
		return coordinates
	end

	def draw_board
		toDraw = ""
		i = 0

		while i < @grid.length  do
		   i2 = 0
		   
		   while i2 < @grid[i].length do
				if(@grid[i][i2])
					toDraw << @grid[i][i2].to_s
				else
					toDraw << "-"
				end
				i2 += 1
		   end
	
		   i += 1

		   toDraw << "\n"
		end

		puts toDraw
	end
end