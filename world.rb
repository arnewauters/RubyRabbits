require_relative 'rabbit'
require_relative 'fox'
require_relative 'coordinate'

require 'benchmark'

require 'curses'
include Curses

class World

	def initialize

		fieldSize = 50
		
		@grid = Hash.new(:free)
		@coordinates = []

		numfoxes = 100 + rand(8)	
		gridSize = fieldSize * fieldSize	
		range = 1..gridSize
		range = range.to_a
		foxindexes = range.sample(numfoxes)

		numrabbits = 800 + rand(12)		
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
			
			# act
			# breed
			# move
			# draw_board

			Benchmark.bm(7) do |x|
			  x.report("act:")   { act }
			  x.report("breed:") { breed }
			  x.report("move:")  { move }
			  x.report("render:")  { draw_board }
			end

			addstr("Pass #{pass}")

			

			refresh
			setpos(0,0)
			pass += 1
			gets
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
					
					adjacentCoordinates = calculate_free_adjacent_coordinates(coordinate)

					babies = item.breed(adjacentCoordinates.count)

					if (babies)
						dropCoordinates = adjacentCoordinates.sample(babies.count)
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
					
					adjacentCoordinates = calculate_free_adjacent_coordinates(coordinate)

					if item.kind_of?(Fox)
						eatableBunnies = {}
						adjacentCoordinates.each do |freeCoordinate|
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

				    if adjacentCoordinates.count == 0
						@grid[coordinate] = :grave
						item = nil
					else
						newCoordinate = adjacentCoordinates.sample
						@grid[newCoordinate] = item
						@grid[coordinate] = :used
					end
				end
			end
		end
	end

	def calculate_free_adjacent_coordinates(coordinate)
		adjacentCoordinates = []

		adjacentCoordinates << Coordinate.new(coordinate.x - 1, coordinate.y - 1)
		adjacentCoordinates << Coordinate.new(coordinate.x, coordinate.y - 1)
		adjacentCoordinates << Coordinate.new(coordinate.x + 1, coordinate.y - 1)

		adjacentCoordinates << Coordinate.new(coordinate.x - 1, coordinate.y)
		adjacentCoordinates << Coordinate.new(coordinate.x + 1, coordinate.y)
		
		adjacentCoordinates << Coordinate.new(coordinate.x - 1, coordinate.y + 1)
		adjacentCoordinates << Coordinate.new(coordinate.x, coordinate.y + 1)
		adjacentCoordinates << Coordinate.new(coordinate.x + 1, coordinate.y + 1)

		adjacentCoordinates.delete_if { |c| @coordinates.include? c && @grid[c].kind_of?(Animal) }
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

