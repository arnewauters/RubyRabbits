require_relative 'rabbit'
require_relative 'fox'
require_relative 'coordinate'

require 'benchmark'

require 'curses'
include Curses

class World

	def initialize

		@fieldSize = 50
		@grid = Hash.new(:free)
		@coordinates = []
		@adjacentCoordinates = {}
		@deadCoordinates = []
		@processedCoordinates = []
		
		initialize_grid
		build_adjacent_coordinates

		start()
	end

	def start
		pass = 0
		while pass < 50 do
			
			act
			cleanup
			draw_board

			setpos(54, 1)
			addstr("Pass: #{pass}")

			refresh
			#gets
			pass += 1
			
		end
	end

	private

	def initialize_grid
		numfoxes = 4 + rand(8)
		gridSize = @fieldSize * @fieldSize	
		range = 1..gridSize
		range = range.to_a
		foxindexes = range.sample(numfoxes)

		numrabbits = 4 + rand(8)	
		rabbittindexes = range.sample(numrabbits)

		for x in 1..@fieldSize
			for y in 1..@fieldSize
				
				coordinate = Coordinate.new(x, y)
				@coordinates << coordinate

				index = ((y - 1) * @fieldSize) + x 
				
				#if x.odd?
				if foxindexes.include? index
					@grid[coordinate] = Fox.new()
					next
				end

				#if x.even?
				if rabbittindexes.include? index
					@grid[coordinate] = Rabbit.new()
					next
				end
			end
		end 
	end

	def build_adjacent_coordinates
		@coordinates.each do |coordinate|
			adjacentCoordinates = []

			if coordinate.x > 1 && coordinate.y > 1
				adjacentCoordinates << Coordinate.new(coordinate.x - 1, coordinate.y - 1)
			end

			if coordinate.y > 1
				adjacentCoordinates << Coordinate.new(coordinate.x, coordinate.y - 1)
			end

			if coordinate.x < @fieldSize && coordinate.y > 1
				adjacentCoordinates << Coordinate.new(coordinate.x + 1, coordinate.y - 1)
			end

			if coordinate.x > 1
				adjacentCoordinates << Coordinate.new(coordinate.x - 1, coordinate.y)
			end

			if coordinate.x < @fieldSize
				adjacentCoordinates << Coordinate.new(coordinate.x + 1, coordinate.y)
			end

			if coordinate.x > 1 && coordinate.y < @fieldSize
				adjacentCoordinates << Coordinate.new(coordinate.x - 1, coordinate.y + 1)
			end

			if coordinate.y < @fieldSize
				adjacentCoordinates << Coordinate.new(coordinate.x, coordinate.y + 1)
			end

			if coordinate.x < @fieldSize && coordinate.y < @fieldSize
				adjacentCoordinates << Coordinate.new(coordinate.x + 1, coordinate.y + 1)
			end

			@adjacentCoordinates[coordinate] = adjacentCoordinates
		end
	end

	def act
		
		liveAtStart = 0
		births = 0
		hunted = 0
		deathByAgeOrHunger = 0
		deathBySpace = 0
		accessInner = 0

		@processedCoordinates.clear

		@coordinates.each do |coordinate|
			item = @grid[coordinate]
			
			if (item.kind_of?(Animal))
				liveAtStart += 1
			end

			if !(@processedCoordinates.include? coordinate) && item.kind_of?(Animal)
				accessInner += 1
				item.act
				
				if item.dead
					deathByAgeOrHunger += 1
					@deadCoordinates << coordinate
				else
					adjacentCoordinates = @adjacentCoordinates[coordinate]
				
					if item.kind_of?(Fox)
						eatableBunnies = []
						adjacentCoordinates.each do |adjacentCoordinate|
							if @grid[adjacentCoordinate].kind_of?(Rabbit)
								eatableBunnies << adjacentCoordinate
							end
						end

						if eatableBunnies.count > 0
							prayLocation = eatableBunnies.sample
							item.eat(@grid[prayLocation])
							@grid[prayLocation] = item
							adjacentCoordinates = @adjacentCoordinates[prayLocation]
							coordinate = prayLocation
							@processedCoordinates << prayLocation
							hunted += 1
						end
					end

					adjacentCoordinates.delete_if { |c| @grid[c].kind_of?(Animal) }

					 if adjacentCoordinates.count == 0
						item.kill
						deathBySpace += 1
						@deadCoordinates << coordinate
					else
						
						babies = item.breed(adjacentCoordinates.count)

						if (babies)
							births += babies.count
							dropCoordinates = adjacentCoordinates.sample(babies.count)
							dropCoordinates.each do |dropCoordinate|
						 		@grid[dropCoordinate] = babies[dropCoordinates.index(dropCoordinate)]
						 		@processedCoordinates << dropCoordinate
							end
						end

						adjacentCoordinates.delete_if { |c| @grid[c].kind_of?(Animal) }
						 
						if adjacentCoordinates.count == 0
							item.kill
							deathBySpace += 1
							@deadCoordinates << coordinate
						else
							newCoordinate = adjacentCoordinates.sample
							@grid[newCoordinate] = item
							@processedCoordinates << newCoordinate
							@grid[coordinate] = :used
						end
					end
				end
			end
		end

		setpos(52, 1)
		addstr("Access: #{accessInner}, Births: #{births}, Hunted: #{hunted}, Death By Age/Hunger: #{deathByAgeOrHunger}, Death By Space: #{deathBySpace}")
	end

	def cleanup
		setpos(53, 1)
		addstr("Deaths: #{@deadCoordinates.count}")

		@deadCoordinates.each do |dead| 
			@grid[dead] = :grave
		end

		@deadCoordinates.clear
	end

	def draw_board
		for x in 1..@fieldSize
			for y in 1..@fieldSize
				
				setpos(y, x)
				coordinate = Coordinate.new(x, y)
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
			end
		end
	end
end

