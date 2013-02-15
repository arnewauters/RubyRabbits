require_relative 'animal'
require 'win32console'
require 'colored'

class Rabbit < Animal
	def to_s
		x = "R"
		x.green
	end
end