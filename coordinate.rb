class Coordinate

	attr_reader :x, :y
	
	def initialize(x, y)
		@x = x
		@y = y
	end

	def eql?(object)

		if object.equal?(self)
			return true
		elseif !self.class.equal?(object.class)
			return false
		end

		return object.x == @x && object.y == @y
	end

	def hash
		[@x, @y].hash
	end

	def to_s
		puts "#{x} - #{y}"
	end
end