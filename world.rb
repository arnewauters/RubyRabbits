require_relative 'rabbit'
require_relative 'fox'

class World

	def initialize
		fieldSize = 50

		puts "Initializing world..."
		@grid = Array.new(fieldSize) { Array.new(fieldSize, :free) }

		draw_board()
		gets
		
		numfoxes = 2 + rand(3)

		for i in 0..numfoxes-1
			notAssigned = true

			while notAssigned
				x = rand(fieldSize)
				y = rand(fieldSize)

				if @grid[x][y] == :free
					@grid[x][y] = Fox.new()
					notAssigned = false
				end
			end
			i += 1
		end
		
		numrabbits = 5 + rand(10)

		for z in 0..numrabbits-1
			notAssigned = true

			while notAssigned
				x = rand(fieldSize)
				y = rand(fieldSize)

				if @grid[x][y] == :free
					@grid[x][y] = Rabbit.new()
					notAssigned = false
				end
			end
			z += 1
		end
		
		system("cls")
		draw_board()
		puts "Breeded and deployed #{numfoxes} foxes..."
		puts "Breeded and deployed #{numrabbits} rabbits..."
		gets

		start()
	end

	def start
		
		pass = 0
		while pass < 25 do
			
			i = 0

			handled =[]

			while i < @grid.length  do
		   		i2 = 0
		   		while i2 < @grid[i].length do
		   		
		   			item = @grid[i][i2]

			   		if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
						if (! handled.include? item)
							
							handled << item

							item.act

							if item.dead
								@grid[i][i2] = :grave
							else
								coordinates = calculateFreeAdjacentLocations([i2, i])
								babies = item.breed(coordinates.count)

								if (babies)
									selectedLocations = coordinates.sample(babies.count)
										selectedLocations.each do |loc|
								 		@grid[loc[1]][loc[0]] = babies[selectedLocations.index(loc)]
								 		handled << babies[selectedLocations.index(loc)]
									end
								end

								coordinates = calculateFreeAdjacentLocations([i2, i])
							    chosenPath = item.move(coordinates)
							    
							    if item.dead
									@grid[i][i2] = :grave
								else
									@grid[chosenPath[1]][chosenPath[0]] = item
									@grid[i][i2] = :used
								end
							end
						end
					end		
					i2 += 1
		   		end
		   		i += 1
		   	end
			
			system("cls")
			draw_board()
			puts "Pass #{pass}"
			
			sleep(0.5)
			pass += 1
		end
	end

	private

	def calculateFreeAdjacentLocations(coordinate)
		x, y = -1
		coordinates = Array.new()
		
		@grid.each do |gridRow|
			for i in -1..1
	   			for z in -1..1
	   				unless (i == 0 && z == 0)

		   				newY = coordinate[1] + i
		   				newX = coordinate[0] + z

		   				if newY >= 0 && newY < @grid.length && newX >= 0 && newX < gridRow.length
		   					if @grid[newY][newX] == :free || @grid[newY][newX] == :used || @grid[newY][newX] == :grave
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
				
				toDraw << "+" if (@grid[i][i2] == :grave) 
				toDraw << "." if (@grid[i][i2] == :used) 
				toDraw << "-" if (@grid[i][i2] == :free)  
				toDraw << @grid[i][i2].to_s if(@grid[i][i2].kind_of?(Rabbit) || @grid[i][i2].kind_of?(Fox))
				
				i2 += 1
		   end
	
		   i += 1

		   toDraw << "\n"
		end

		puts toDraw
	end
end