# Define opcode mappings
# pg 558 of https://ia601800.us.archive.org/4/items/The_8086_Book_Russell_Rector_George_Alexy/The_8086_Book_Russell_Rector_George_Alexy.pdf
# INSTRUCTION_MAP = {
#   [0x89, 0xD9] => 'mov cx, bx'
# }

require 'debug'

EIGHT_BIT_REGISTERS = {
  0b000 => 'AL',
  0b001 => 'CL',
  0b010 => 'DL',
  0b011 => 'BL',
  0b100 => 'AH',
  0b101 => 'CH',
  0b110 => 'DH',
  0b111 => 'BH'

}

SIXTEEN_BIT_REGISTERS = {
  0b000 => 'AX',
  0b001 => 'CX',
  0b010 => 'DX',
  0b011 => 'BX',
  0b100 => 'SP',
  0b101 => 'BP',
  0b110 => 'SI',
  0b111 => 'DI'
}

def decode_8086(file_path)
  bytes = File.binread(file_path).bytes
  i = 0

  while i < bytes.length
    if i  < bytes.length
      if (bytes[i] & 0b11111100) >> 2 == 0b100010
        opcode = 'mov'
        reg_field_is_source = (bytes[i] & 0b00000010) >> 1 == 0
        instruction_operates_on_byte_data = (bytes[i] & 0b00000001) == 0

        if i + 1 < bytes.length

          register_to_register_operation = ((bytes[i + 1] & 0b11000000) >> 6) == 0b11
          if register_to_register_operation
            reg_field = (bytes[i + 1] & 0b00111000) >> 3
            r_m_field = bytes[i + 1] & 0b00000111
            if instruction_operates_on_byte_data
              if reg_field_is_source
                source = EIGHT_BIT_REGISTERS[reg_field]
                destination = EIGHT_BIT_REGISTERS[r_m_field]
              else
                source = EIGHT_BIT_REGISTERS[r_m_field]
                destination = EIGHT_BIT_REGISTERS[reg_field]
              end

            elsif reg_field_is_source
              source = SIXTEEN_BIT_REGISTERS[reg_field]
              destination = SIXTEEN_BIT_REGISTERS[r_m_field]
            else
              source = SIXTEEN_BIT_REGISTERS[r_m_field]
              destination = SIXTEEN_BIT_REGISTERS[reg_field]
            end
          end
          i += 1
        else
          puts "Incomplete instruction: #{format('%04b',
                                                 i)}: #{format('%02b', bytes[i])}     =>  Incomplete instruction"
        end
        output = "#{opcode} #{source}, #{destination}".upcase
        puts(output)
      else
        puts "Unknown instruction: #{format('%04b', i)}: #{format('%02b', bytes[i])}     =>  Unknown instruction"
      end
    else
      puts "#{format('%04b', i)}: #{format('%02b', bytes[i])}     =>  Incomplete instruction"
    end
    i += 1
  end
end

# Replace with the path to your binary file
binary_file = 'single_register_mov'
decode_8086(binary_file)
