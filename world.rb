require_relative 'rabbit'
require_relative 'fox'

class World

	def initialize
		fieldSize = 50
		puts "Initializing world..."
		
		@grid = Hash.new(:free)
		
		numfoxes = 2 + rand(3)	
		gridSize = fieldSize * fieldSize	
		range = 1..gridSize
		range = range.to_a
		foxindexes = range.sample(numfoxes)

		numrabbits = 5 + rand(10)		
		rabbittindexes = range.sample(numrabbits)

		for x in 1 ..fieldSize
			for y in 1..fieldSize
				index = ((y - 1) * fieldSize) + x 
				
				if foxindexes.include? index
					@grid[[x, y]] = Fox.new()
					next
				end

				if rabbittindexes.include? index
					@grid[[x, y]] = Rabbit.new()
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
			gets
			system("cls")
			#sleep(0.2)
			pass += 1
		end
	end

	private

	def act
		for x in 1 .. 50
			for y in 1..50
				item = @grid[[x,y]]
				if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
					item.sleeping = false
					item.act
					if item.dead
						@grid[[x,y]] = :grave
					end
				end
			end
		end
	end

	def breed
		for x in 1 .. 50
			for y in 1..50
				item = @grid[[x, y]]
				if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
					if(item.age != -1)
						
						coordinates = calculateFreeAdjacentLocations([x, y])
						babies = item.breed(coordinates.count)

						if (babies)
							selectedLocations = coordinates.sample(babies.count)
							selectedLocations.each do |loc|
						 		@grid[[loc[0],loc[1]]] = babies[selectedLocations.index(loc)]
							end
						end
					end
				end
			end
		end
	end

	def move
		for x in 1 .. 50
			for y in 1..50
				item = @grid[[x, y]]
				if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
					if !item.sleeping
							item.sleeping = true
							
							coordinates = calculateFreeAdjacentLocations([x, y])
						    if coordinates.count == 0
								@grid[[x, y]] = :grave
							else
								loc = item.move(coordinates)
								@grid[[loc[0],loc[1]]] = item
								@grid[[x, y]] = :used
							end
					end
				end
			end
		end
	end

	def calculateFreeAdjacentLocations(coordinate)
		coordinates = []
		for i in -1..1
   			for z in -1..1
   				unless (i == 0 && z == 0)
	   				newX = coordinate[0] + i
	   				newY = coordinate[1] + z

	   				if newY > 0 && newY < 51 && newX > 0 && newX < 51
	   					item = @grid[[newX, newY]]
	   					if(!item.kind_of?(Rabbit) && !item.kind_of?(Fox))
	   						toAdd = [newX, newY]
	   						coordinates << toAdd
	   					end
	   				end 
   				end
   			end
		end
		return coordinates
	end

	def draw_board
		toDraw = ""
		for y in 1 .. 50
			for x in 1..50
				item = @grid[[x, y]] 
				toDraw << "+" if (item == :grave) 
				toDraw << "." if (item == :used) 
				toDraw << "-" if (item == :free) 
				toDraw << "o" if (item == :marker)  
				if(item.kind_of?(Rabbit) || item.kind_of?(Fox))
					if item.age == -1
						toDraw << "B"
					else
						toDraw << item.to_s 
					end
				end
			end
			toDraw << "\n"
		end
		puts toDraw
	end
end