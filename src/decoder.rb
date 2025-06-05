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
  i = 0
  output = ''
  get_source = proc { |reg_field_is_source, register_set, reg_field, r_m_field|
    # binding.break
    reg_field_is_source ? register_set[reg_field] : register_set[r_m_field]
  }.curry
  get_destination = proc { |reg_field_is_source, register_set, reg_field, r_m_field|
    reg_field_is_source ? register_set[r_m_field] : register_set[reg_field]
  }.curry
  while i < bytes.length
    is_mov_instruction = (bytes[i] & 0b11111100) >> 2 == 0b100010
    if is_mov_instruction
      opcode = 'mov'
      reg_field_is_source = (bytes[i] & 0b00000010) >> 1 == 0
      source = get_source.call(reg_field_is_source)
      destination = get_destination.call(reg_field_is_source)
      instruction_operates_on_byte_data = (bytes[i] & 0b00000001) == 0

      unless i + 1 < bytes.length
        return puts "#{format('%04b', i)}: #{format('%02b', bytes[i])}     =>  Incomplete instruction"
      end

      mod_field = (bytes[i + 1] & 0b11000000) >> 6
      case mod_field
      when 0b11 # Register to register
        reg_field = (bytes[i + 1] & 0b00111000) >> 3
        r_m_field = bytes[i + 1] & 0b00000111
        register_set = instruction_operates_on_byte_data ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
        source = source.call(register_set).call(reg_field).call(r_m_field)
        destination = destination.call(register_set).call(reg_field).call(r_m_field)
      end
      output << "#{format('%08X',
                          i)}  #{format('%2X',
                                        bytes[i])}#{format('%2X',
                                                           bytes[i + 1])}              #{opcode} #{destination},#{source}\n"
      i += 1
    else
      puts "#{format('%04b', i)}: #{format('%02b', bytes[i])}     =>  Unknown instruction"
    end
    i += 1
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

# Replace with the path to your binary file
binary_file = 'many_register_movs'
decode_8086(binary_file)
