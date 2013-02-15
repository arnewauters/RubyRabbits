require_relative 'rabbit'
require_relative 'fox'

class World

	def initialize
		fieldSize = 50

		puts "Initializing world..."
		@locations = Array.new(fieldSize) { Array.new(fieldSize) }

		puts "Breeding random number of foxes between 2 and 5..."
		@foxes = Array.new(2 + rand(3), Fox.new())
		
		@foxes.each do |fox|
			notAssigned = true

			while notAssigned
				x = rand(fieldSize)
				y = rand(fieldSize)

				unless @locations[x][y] 
					@locations[x][y] = fox
					notAssigned = false
					#puts "Assigned fox to x: #{x} and y: #{y}"
				end
			end
		end

		puts "Breeded and deployed #{@foxes.length} foxes..."

		puts "Breeding random number of rabbits between 5 and 25..."
		@rabbits = Array.new(5 + rand(20), Rabbit.new())
		
		@rabbits.each do |rabbit|
			notAssigned = true

			while notAssigned
				x = rand(fieldSize)
				y = rand(fieldSize)

				unless @locations[x][y] 
					@locations[x][y] = rabbit
					notAssigned = false
					#puts "Assigned rabbit to x: #{x} and y: #{y}"
				end
			end
		end

		puts "Breeded and deployed #{@rabbits.length} rabbits..."
		puts "Starting simulation sequence in 5 seconds!"

		sleep(5)
		system("cls")

		start()
	end

	def start
		i = 0
		while i < 25 do
			system("cls")
			draw_board()
			i += 1
		end

	end

	private

	def draw_board
		toDraw = ""
		i = 0

		while i < @locations.length  do
		   i2 = 0
		   
		   while i2 < @locations[i].length do
				if(@locations[i][i2])
					toDraw << @locations[i][i2].to_s
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