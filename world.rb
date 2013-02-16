require_relative 'rabbit'
require_relative 'fox'

class World

	def initialize
		fieldSize = 50
		@newborns = []
		puts "Initializing world..."
		@grid = Array.new(fieldSize) { Array.new(fieldSize) { :free } }

		draw_board()
		gets
		
		numfoxes = 1

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
		
		# numrabbits = 5 + rand(10)

		# for z in 0..numrabbits-1
		# 	notAssigned = true

		# 	while notAssigned
		# 		x = rand(fieldSize)
		# 		y = rand(fieldSize)

		# 		if @grid[x][y] == :free
		# 			@grid[x][y] = Rabbit.new()
		# 			notAssigned = false
		# 		end
		# 	end
		# 	z += 1
		# end
		
		system("cls")
		draw_board()
		puts "Breeded and deployed #{numfoxes} foxes..."
		#puts "Breeded and deployed #{numrabbits} rabbits..."
		gets

		start()
	end

	def start
		pass = 0
		while pass < 100 do
			
			@newborns = []

			act
			breed
			move

			system("cls")
			draw_board()
			puts "Pass #{pass}"
			gets
			#sleep(0.2)
			pass += 1
		end
	end

	private

	def act
		i = 0
		while i < @grid.length  do
	   		i2 = 0
	   		while i2 < @grid[i].length do
	   		
	   			item = @grid[i][i2]

		   		if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
					item.act
					if item.dead
						@grid[i][i2] = :grave
					end
				end
				i2 += 1
			end
			i += 1
		end
	end

	def breed
		
		i = 0
		handled = Array.new()

		while i < @grid.length  do
	   		i2 = 0
	   		while i2 < @grid[i].length do
	   			item = @grid[i][i2]
	   			if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
					unless handled.include? [i2, i]
						
						handled << [i2, i]
						
						coordinates = calculateFreeAdjacentLocations([i2, i])
						babies = item.breed(coordinates.count)


						if (babies)
							@newborns = @newborns + babies
							selectedLocations = coordinates.sample(babies.count)
							selectedLocations.each do |loc|
						 		@grid[loc[1]][loc[0]] = babies[selectedLocations.index(loc)]
						 		handled << [loc[0], loc[1]]
							end
						end
					end	
				end
				i2 += 1
			end
			i += 1
		end
	end

	def move
		i = 0

		handled = Array.new()

		while i < @grid.length  do
	   		i2 = 0
	   		while i2 < @grid[i].length do
	   			item = @grid[i][i2]
	   			unless @newborns.include? item
		   			if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
						unless handled.include? [i2, i]
							
							handled << [i2, i]
						
							coordinates = calculateFreeAdjacentLocations([i2, i])
						    if(coordinates == [])
								@grid[i][i2] = :grave
							else
								chosenPath = item.move(coordinates)
								@grid[chosenPath[1]][chosenPath[0]] = item
								handled << [chosenPath[0], chosenPath[1]]
								@grid[i][i2] = :used
							end
						end	
					end
				end
			i2 += 1
			end
		i += 1
		end
	end

	def calculateFreeAdjacentLocations(coordinate)

		coordinates = Array.new()
		
		for i in -1..1
   			for z in -1..1
   				unless (i == 0 && z == 0)

	   				newX = coordinate[0] + i
	   				newY = coordinate[1] + z

	   				if newY >= 0 && newY < @grid.length && newX >= 0 && newX < @grid[0].length
	   					notTaken = @grid[newY][newX] == :free || @grid[newY][newX] == :used || @grid[newY][newX] == :grave || @grid[newY][newX] == :marker
	   					if(notTaken)
	   						coordinates << [newX, newY]
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
				toDraw << "o" if (@grid[i][i2] == :marker)  
				if(@grid[i][i2].kind_of?(Rabbit) || @grid[i][i2].kind_of?(Fox))
					if @newborns.include? @grid[i][i2]
						toDraw << "B" 
					else
						toDraw << @grid[i][i2].to_s 
					end
				end
				
				i2 += 1
		   end
	
		   i += 1

		   toDraw << "\n"
		end

		puts toDraw
	end
end