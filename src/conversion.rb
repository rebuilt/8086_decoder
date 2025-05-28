# Binary literals
num = 0b1010101010
num.class # => Integer

# Convert to binary string
binary_str = num.to_s(2)
puts "Binary representation: #{binary_str}" # => "1010101010"

# Convert to hexadecimal string
hex_str = num.to_s(16)
puts "Hexadecimal representation: #{hex_str}" # => "2aa"

# Convert to octal string
octal_str = num.to_s(8)
puts "Octal representation: #{octal_str}" # => "252"

# Convert from binary string to integer
binary_num = '1010101010'.to_i(2)
puts "Converted back from binary: #{binary_num}" # => 682

# Convert from hexadecimal string to integer
hex_num = '2aa'.to_i(16)
puts "Converted back from hexadecimal: #{hex_num}" # => 682

# Convert from octal string to integer
octal_num = '252'.to_i(8)
puts "Converted back from octal: #{octal_num}" # => 170
