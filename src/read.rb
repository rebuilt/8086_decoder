descriptor = IO.sysopen('single_register_mov')
io = IO.new(descriptor)

byte = io.sysread(1)
puts(byte.unpack('C*').map { |decimal| decimal.to_s(2) })
io.sysseek(0)

puts "it's a mov instruction" if (byte.unpack1('C') & 11_111_100) == 0b10001000

bytes = io.readpartial(2)
puts(bytes.unpack('C*').map { |decimal| decimal.to_s(2) })
io.sysseek(0)
