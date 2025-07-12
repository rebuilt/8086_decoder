# Define opcode mappings
# pg 558 of https://ia601800.us.archive.org/4/items/The_8086_Book_Russell_Rector_George_Alexy/The_8086_Book_Russell_Rector_George_Alexy.pdf
# INSTRUCTION_MAP = {
#   [0x89, 0xD9] => 'mov cx, bx'
# }

require 'debug'
class Integer
  def to_bin
    to_s(2).rjust(8, '0')
  end
end

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

EFFECTIVE_ADDRESS_MODE_00 = {
  0b000 => 'bx+si',
  0b001 => 'bx+di',
  0b010 => 'bp+si',
  0b011 => 'bp+di',
  0b100 => 'si',
  0b101 => 'di',
  0b110 => 'Direct address',
  0b111 => 'bx'
}

EFFECTIVE_ADDRESS_MODE_01 = {
  0b000 => 'bx+si',
  0b001 => 'bx+di',
  0b010 => 'bp+si',
  0b011 => 'bp+di',
  0b100 => 'si',
  0b101 => 'di',
  0b110 => 'bp',
  0b111 => 'bx'
}

EFFECTIVE_ADDRESS_MODE_10 = {
  0b000 => 'bx+si',
  0b001 => 'bx+di',
  0b010 => 'bp+si',
  0b011 => 'bp+di',
  0b100 => 'si',
  0b101 => 'di',
  0b110 => 'bp',
  0b111 => 'bx'
}

# Decode the binary file and print the instructions
def decode_8086(filepath)
  bytes = File.binread(filepath).bytes
  index = 0
  output = ''
  while index < bytes.length

    case bytes[index]
    when 0b10001000..0b10001011 # Register/memory to/from register
      opcode = 'mov'
      d = (bytes[index] & 0b00000010) >> 1
      w = (bytes[index] & 0b00000001)

      return unless index + 1 < bytes.length

      mod_field = (bytes[index + 1] & 0b11000000) >> 6
      r_m_field = bytes[index + 1] & 0b00000111
      reg_field = (bytes[index + 1] & 0b00111000) >> 3
      register_type = w.zero? ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS

      effective_address = case mod_field
                          when 0b00
                            EFFECTIVE_ADDRESS_MODE_00
                          when 0b01
                            EFFECTIVE_ADDRESS_MODE_01
                          when 0b10
                            EFFECTIVE_ADDRESS_MODE_10
                          when 0b11
                            w == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
                          end
      source = d.zero? ? register_type[reg_field] : effective_address[r_m_field]
      destination = d.zero? ? effective_address[r_m_field] : register_type[reg_field]

      if mod_field == 0b00 && r_m_field == 0b110 # Direct address, 16 bit displacement
        source = "+0x#{bytes[index + 2].to_s(16)}"
      end

      if mod_field == 0b01 # Direct address, 8 bit displacement
        effective_address_var = "+0x#{bytes[index + 2].to_s(16)}"
        d.zero? ? destination += effective_address_var : source += effective_address_var
        index += 1
      end

      if mod_field == 0b10 # Direct address, 8 bit displacement
        effective_address_var = "+0x#{bytes[index + 2..index + 3].pack('C*').unpack1('v').to_s(16)}"

        d.zero? ? destination += effective_address_var : source += effective_address_var
        index += 2
      end

      if mod_field != 0b11
        d.zero? ? destination = "[#{destination}]" : source = "[#{source}]"
      end
      output << "#{opcode} #{destination},#{source}\n"
      index += 1

    when 0b10110000..0b10111111 # MOV immediate to register
      opcode = 'mov'
      w = ((bytes[index] & 0b00001000) >> 3)
      register_code = (bytes[index] & 0b00000111)
      register_type = w == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
      destination = register_type[register_code]
      source = w == 0 ? "0x#{bytes[index + 1].to_s(16)}" : "0x#{bytes[index + 1..index + 2].pack('C*').unpack1('v').to_s(16)}"

      output << "#{opcode} #{destination},#{source}\n"
      index += w == 0 ? 1 : 2
    when 0b10100000..0b10100001 # MOV memory to accumulator.
      opcode = 'mov'
      w = bytes[index] & 0b00000001
      destination = w == 0 ? 'al' : 'ax'
      source = w == 0 ? "0x#{bytes[index + 1].to_s(16)}" : "0x#{bytes[index + 1..index + 2].pack('C*').unpack1('v').to_s(16)}"
      source = "[#{source}]"
      output << "#{opcode} #{destination},#{source}\n"
      index += w == 0 ? 1 : 2
    when 0b10100010..0b10100011 # MOV accumulator to memory.
      opcode = 'mov'
      w = bytes[index] & 0b00000001
      source = w == 0 ? 'al' : 'ax'
      destination = w == 0 ? "0x#{bytes[index + 1].to_s(16)}" : "0x#{bytes[index + 1..index + 2].pack('C*').unpack1('v').to_s(16)}"
      destination = "[#{destination}]"
      output << "#{opcode} #{destination},#{source}\n"
      index += w == 0 ? 1 : 2
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
binary_file ||= './asm/single_register_mov'

decode_8086(binary_file)
