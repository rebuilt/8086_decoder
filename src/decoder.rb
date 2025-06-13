# Define opcode mappings
# pg 558 of https://ia601800.us.archive.org/4/items/The_8086_Book_Russell_Rector_George_Alexy/The_8086_Book_Russell_Rector_George_Alexy.pdf
# INSTRUCTION_MAP = {
#   [0x89, 0xD9] => 'mov cx, bx'
# }

require 'debug'

EIGHT_BIT_REGISTERS = {
  0b000 => 'al',
  0b010 => 'dl',
  0b001 => 'cl',
  0b011 => 'bl',
  0b100 => 'ah',
  0b111 => 'bh',
  0b101 => 'ch',
  0b110 => 'dh'

}

SIXTEEN_BIT_REGISTERS = {
  0b000 => 'ax',
  0b011 => 'bx',
  0b001 => 'cx',
  0b010 => 'dx',
  0b100 => 'sp',
  0b101 => 'bp',
  0b110 => 'si',
  0b111 => 'di'
}

# Decode the binary file and print the instructions
def decode_8086(file_path)
  bytes = File.binread(file_path).bytes
  index = 0
  output = ''
  while index < bytes.length
    # is_mov_instruction = (bytes[index] & 0b11111100) >> 2 == 0b100010
    case bytes[index]
    when 0b10001000..0b10001111 # MOV instruction

      opcode = 'mov'
      d_field = d(bytes[index])
      w_field = w(bytes[index])

      return puts "#{format('%02b', bytes[index])}     =>  Incomplete instruction" unless index + 1 < bytes.length

      mod_field = (bytes[index + 1] & 0b11000000) >> 6
      case mod_field
      when 0b11 # Register to register
        # reg_field = (bytes[index + 1] & 0b00111000) >> 3
        reg_field = reg(bytes[index + 1])
        r_m_field = r_m(bytes[index + 1])
        register_set = w(bytes[index]) == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
        source = d_field == 0 ? register_set[reg_field] : register_set[r_m_field]
        destination = d_field == 0 ? register_set[r_m_field] : register_set[reg_field]
        output << "#{opcode} #{destination},#{source}\n"
        index += 1
      end
    when 0b10110000..0b10111111 # MOV immediate to register
      opcode = 'mov'
      w_field = w(bytes[index], 0b00001000)
      reg_field = (bytes[index] & 0b00000111)
      register_set = w_field == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
      destination = register_set[reg_field]
      source = w_field == 0 ? "0x#{bytes[index + 1].to_s(16)}" : "0x#{bytes[index + 1..index + 2].pack('C*').unpack1('v').to_s(16)}"

      output << "#{opcode} #{destination},#{source}\n"
      index += w_field == 0 ? 1 : 2
    else
      puts "#{format('%04b', index)}: #{format('%02b', bytes[index])}     =>  Unknown instruction"
    end
    index += 1
  end
  puts output
end

def d(byte, mask = 0b00000010)
  bit_length = mask.bit_length.clamp(0..)
  (byte & mask) >> bit_length - 1
end

def w(byte, mask = 0b00000001)
  bit_length = mask.bit_length.clamp(0..)
  (byte & mask) >> bit_length - 1
end

def reg(byte, mask = 0b00111000, shift = 3)
  bit_length = mask.bit_length.clamp(0..)
  (byte & mask) >> bit_length - shift
end

def r_m(byte, mask = 0b00000111)
  byte & mask
end

# {}
# instruction = {:byte => Byte}
# |> decode_opcode_from_byte(instruction)
# |> decode_direction(instruction)
# |> decode_word(instruction)
# |> decode_mod(instruction)
# |> decode_register(instruction)
# |> decode_r_m(instruction)

# Replace with the path to your binary File
binary_file = ARGV[0]
binary_file ||= 'more_movs'

decode_8086(binary_file)
