require 'debug'

EIGHT_BIT_REGISTERS = {
  0b000 => 'al',
  0b011 => 'bl',
  0b001 => 'cl',
  0b010 => 'dl',
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
  0b111 => 'bp',
  0b101 => 'si',
  0b110 => 'di'
}

def decode_8086(filepath)
  bytes = File.read(filepath).bytes
  index = 0
  output = []

  while index < bytes.length
    case bytes[index]
    when 0xB0..0xB7  # MOV r8, imm8
      reg = EIGHT_BIT_REGISTERS[(bytes[index] & 0b111).to_i]
      index += 1
      imm8 = bytes[index]
      output << "MOV #{reg}, #{imm8}"
      index += 1

    when 0xB8..0xBF  # MOV r16, imm16
      reg = SIXTEEN_BIT_REGISTERS[(bytes[index] & 0b111).to_i]
      index += 1
      imm16 = (bytes[index] | (bytes[index + 1] << 8))
      output << "MOV #{reg}, #{imm16}"
      index += 2

    when 0xC0..0xC7  # ROL r/m8, imm8
      modrm = bytes[index + 1]
      reg = EIGHT_BIT_REGISTERS[(modrm & 0b111).to_i]
      index += 2
      imm8 = bytes[index]
      output << "ROL #{reg}, #{imm8}"
      index += 1

    when 0xC8..0xCF # ROL r/m16, imm8
      modrm = bytes[index + 1]
      reg = SIXTEEN_BIT_REGISTERS[(modrm & 0b111).to_i]
      index += 2
      imm8 = bytes[index]
      output << "ROL #{reg}, #{imm8}"
      index += 1

    else
      output << "Unknown opcode: #{bytes[index].to_s(16)}"
      index += 1

    end
  end
  puts output
end

binary_file = ARGV[0]
binary_file ||= 'more_movs'

decode_8086(binary_file)
