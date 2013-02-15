require_relative 'animal'
require 'win32console'
require 'colored'

class Fox < Animal
	def to_s
		x = "F"
		x.red
	end
end