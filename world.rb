require_relative 'rabbit'
require_relative 'fox'
require_relative 'coordinate'

require "curses"
include Curses

class World

	def initialize

		fieldSize = 50
		
		@grid = Hash.new(:free)
		@coordinates = []

		numfoxes = 5 + rand(8)	
		gridSize = fieldSize * fieldSize	
		range = 1..gridSize
		range = range.to_a
		foxindexes = range.sample(numfoxes)

		numrabbits = 5 + rand(12)		
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
		
		system("cls")
		start()
	end

	def start
		pass = 0
		while true do
			
			act
			breed
			move
			
			draw_board()
			addstr("Pass #{pass}")
			
			refresh
			sleep(0.250)
			setpos(0,0)
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

					if item.kind_of?(Fox)
						eatableBunnies = {}
						freeCoordinates.each do |freeCoordinate|
							scannedItem = @grid[freeCoordinate]
							if scannedItem.kind_of?(Rabbit)
								eatableBunnies[freeCoordinate] = scannedItem
							end
						end

						if eatableBunnies.count > 0
							prayLocation = eatableBunnies.keys.sample
							item.eat(@grid[prayLocation])
							@grid[prayLocation] = item
							next
						end
					end

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
		@coordinates.each do |coordinate|
			
			item = @grid[coordinate]

			addstr "+" if (item == :grave) 
			addstr "." if (item == :used) 
			addstr "-" if (item == :free) 
			addstr "o" if (item == :marker)  
			
			if(item.kind_of?(Fox))
				attron (color_pair(COLOR_RED)) do
					addstr item.to_s 
				end
			end

			if(item.kind_of?(Rabbit))
				attron (color_pair(COLOR_GREEN)) do
					addstr item.to_s 
				end
			end

			if(coordinate.y == 50)
				addstr "\n"
			end
		end
	end
end

