puts "\xff\x00\x2a".unpack('CCC')

bits = 13_007
bits.to_s(2) # "11001011001111"
packed = bits.pack('S>')
packed.unpack('S>') # [13007]

# === 16-Bit Integer Directives
#
# * 's' - 16-bit signed integer, native-endian (like C int16_t):
#
#     [513, -514].pack('s*')      # => "\x01\x02\xFE\xFD"
#     s = [513, 65022].pack('s*') # => "\x01\x02\xFE\xFD"
#     s.unpack('s*')              # => [513, -514]
#
# * 'S' - 16-bit unsigned integer, native-endian (like C uint16_t):
#
#     [513, -514].pack('S*')      # => "\x01\x02\xFE\xFD"
#     s = [513, 65022].pack('S*') # => "\x01\x02\xFE\xFD"
#     s.unpack('S*')              # => [513, 65022]
