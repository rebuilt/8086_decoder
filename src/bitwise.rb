def pp(byte)
  puts byte.to_s(2)
end

# AND bitwise operations (& operator)
# Result in 1 if both bits are 1, otherwise 0.

# 0 AND
# 0
# ------
# 0

pp(0b0 & 0b0) # 0

# 0 AND
# 1
# ------
# 0

pp(0b0 & 0b1) # 0

# 1 AND
# 0
# ------
# 0

pp(0b1 & 0b0) # 0

# 1 AND
# 1
# ------
# 1

pp(0b1 & 0b1) # 1

pp(0b1100 & 0b1101) # 0b1100

# OR bitwise operations (| operator)
# Result in 1 if at least one bit is 1, otherwise 0.
#  0 OR
#  0
#  ------
#  0

pp(0b0 | 0b0) # 0

#  0 OR
#  1
#  ------
#  1

pp(0b0 | 0b1) # 1

#  1 OR
#  0
#  ------
#  1
pp(0b1 | 0b0) # 1

#  1 OR
#  1
#  ------
#  1
pp(0b1 | 0b1) # 1

pp(0b1100 | 0b1101) # 0b1101

# XOR bitwise operations (^ operator)
# # Result in 1 if the bits are different, otherwise 0.

#  0 XOR
#  0
#  ------
#  0
pp(0b0 ^ 0b0) # 0

#  0 XOR
#  1
#  ------
#  1
pp(0b0 ^ 0b1) # 1

#  1 XOR
#  0
#  ------
#  1
pp(0b1 ^ 0b0) # 1

#  1 XOR
#  1
#  ------
#  0
pp(0b1 ^ 0b1) # 0

pp(0b1100 ^ 0b1101) # 0b0001

# NOT bitwise operations (~ operator)
# Result in the opposite bit value.
#
# 00000000 00000000 00000000 00000001  = 1
# 11111111 11111111 11111111 11111110  = -2

# Bit shift operations (<< and >> operators)
#  Shift bits to the left (<<) or right (>>) by a specified number of positions.

# 00010111 left-shift
# <-------
# 00101110
#
# 10010111 right-shift
# ------->
# 01001011
#
num = 0b1010101010
padding = 0
while num > 0
  puts("#{' ' * padding}#{num.to_s(2)}")
  num >>= 1
  padding += 1
  sleep 1
  system 'clear'
end

num = 0b1
padding = 20
while num < 4_000
  puts("#{' ' * padding}#{num.to_s(2)}")
  num <<= 1
  padding -= 1
  sleep 1
  system 'clear'
end

# a boolean in ruby is any class that implements the bitwise operators ^ , & , |
#  true.methods - Object.methods
