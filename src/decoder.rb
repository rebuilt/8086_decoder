# Define opcode mappings
# pg 558 of https://ia601800.us.archive.org/4/items/The_8086_Book_Russell_Rector_George_Alexy/The_8086_Book_Russell_Rector_George_Alexy.pdf
# INSTRUCTION_MAP = {
#   [0x89, 0xD9] => 'mov cx, bx'
# }

require 'debug'

EIGHT_BIT_REGISTERS = {
  0b000 => 'al',
  0b001 => 'cl',
  0b010 => 'dl',
  0b011 => 'bl',
  0b100 => 'ah',
  0b101 => 'ch',
  0b110 => 'dh',
  0b111 => 'bh'

}

SIXTEEN_BIT_REGISTERS = {
  0b000 => 'ax',
  0b001 => 'cx',
  0b010 => 'dx',
  0b011 => 'bx',
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
      reg_field_is_source = (bytes[index] & 0b00000010) >> 1 == 0
      instruction_operates_on_byte_data = (bytes[index] & 0b00000001) == 0

      unless index + 1 < bytes.length
        return puts "#{format('%08X',
                              index)}  #{format('%X',
                                                bytes[index])}#{format('%2X',
                                                                       bytes[index + 1])}: #{format('%02b',
                                                                                                    bytes[index])}     =>  Incomplete instruction"
      end

      mod_field = (bytes[index + 1] & 0b11000000) >> 6
      case mod_field
      when 0b11 # Register to register
        reg_field = (bytes[index + 1] & 0b00111000) >> 3
        r_m_field = bytes[index + 1] & 0b00000111
        register_type = instruction_operates_on_byte_data ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
        source = reg_field_is_source ? register_type[reg_field] : register_type[r_m_field]
        destination = reg_field_is_source ? register_type[r_m_field] : register_type[reg_field]
        output << "#{format('%08X',
                            index)}  #{format('%X',
                                              bytes[index])}#{format('%2X',
                                                                     bytes[index + 1])}              #{opcode} #{destination},#{source}\n"
        index += 1
      end
    when 0b10110000..0b10111111 # MOV immediate to register
      opcode = 'mov'
      instruction_operates_on_byte_data = ((bytes[index] & 0b00001000) >> 3) == 0
      register_code = (bytes[index] & 0b00000111)
      register_type = instruction_operates_on_byte_data ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
      destination = register_type[register_code]
      source = instruction_operates_on_byte_data ? "0x#{bytes[index + 1].to_s(16)}" : "0x#{bytes[index + 1..index + 2].pack('C*').unpack1('v').to_s(16)}"

      output << "#{format('%08X',
                          index)}  #{format('%2X',
                                            bytes[index])}#{format('%2X',
                                                                   bytes[index + 1])}              #{opcode} #{destination},#{source}\n"
      index += instruction_operates_on_byte_data ? 1 : 2
    else
      puts "#{format('%04b', index)}: #{format('%02b', bytes[index])}     =>  Unknown instruction"
    end
    index += 1
  end
  puts output
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
