require 'byebug'

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

SR = {
  0b00 => 'es',
  0b01 => 'cs',
  0b10 => 'ss',
  0b11 => 'ds'
}

def direction(bytes, index)
  # Extract destination from bytes at given index
  # 100010 d w
  (bytes[index] >> 1) & 0b1
end

def width(bytes, index)
  # 100010 d w
  bytes[index] & 0b1
end

def get_data(bytes, index, w)
  # data  | data if w == 1

  if w == 0
    if bytes[index] >> 7 & 1 == 1
      bytes[index] - 256
    else
      bytes[index]
    end
  elsif w == 1
    if bytes[index + 1] >> 7 & 1 == 1
      ((bytes[index + 1] << 8) | bytes[index]) - 65_536
    else
      (bytes[index + 1] << 8) | bytes[index]
    end
  end
end

def rm_code(bytes, index)
  # mod reg r/m
  bytes[index] & 0b111
end

def mod_code(bytes, index)
  # mod reg r/m
  bytes[index] >> 6
end

def format(number)
  output = number.to_s(16)
  output.index('-') ? output.insert(1, '0x') : output.insert(0, '0x')
end

# first byte    | second byte | third byte
# 1 0 1 1 w reg | data        | data if w == 1

module ImmediateToRegister
  class << self
    def get_width(bytes, index)
      # 1 0 1 1 w reg
      # (bytes[index] >> 3)  & 0b1
      (bytes[index] & 0b00001000) >> 3
    end

    def get_reg(bytes, index, w)
      # 1 0 1 1 w reg
      register_code = bytes[index] & 0b111
      register_type = w == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
      register_type[register_code]
    end

    def decode(opcode, bytes, index)
      w = get_width(bytes, index)
      reg = get_reg(bytes, index, w)
      data = get_data(bytes, index + 1, w)
      output = "#{opcode} #{reg},#{format(data)}"
      increment = w == 0 ? 2 : 3
      [output, increment]
    end
  end
end

# Register/memory to/from register
# first byte | second byte | third byte | fourth byte
# 100010 d w | mod reg r/m | (DISP-LO)  | (DISP-HI)
module RegisterOrMemoryToOrFromRegister
  class << self
    def reg_code(bytes, index)
      # mod reg r/m
      bytes[index] >> 3 & 0b111
    end

    def register_type(w)
      if w.zero?
        EIGHT_BIT_REGISTERS
      else
        SIXTEEN_BIT_REGISTERS
      end
    end

    def effective_address(mod_code, w)
      case mod_code
      when 0b00
        EFFECTIVE_ADDRESS_MODE_00
      when 0b01
        EFFECTIVE_ADDRESS_MODE_01
      when 0b10
        EFFECTIVE_ADDRESS_MODE_10
      when 0b11
        w == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
      end
    end

    def instruction(opcode, destination, source, displacement)
      "#{opcode} #{destination},#{source} #{displacement}"
    end

    def increment(mod_code, rm_code, w)
      case [mod_code, rm_code, w] # Direct address, 16 bit displacement
      in [0b0, 0b110, 0]
        3
      in [0b0, 0b110, 1]
        4
      in [0b0, _, _]
        2
      in [0b01, _, _]
        3
      in [0b10, _, _]
        4
      in [0b11, _, _]
        2
      end
    end

    def displacement(bytes, index, mod_code)
      if mod_code == 0b10
        if bytes[index + 1] >> 7 & 1 == 1
          ((bytes[index + 1] << 8) | bytes[index]) - 65_536
        else
          (bytes[index + 1] << 8) | bytes[index]
        end
      elsif mod_code == 0b01
        if bytes[index] >> 7 & 1 == 1
          bytes[index] - 256
        else
          bytes[index]
        end
      end
    end

    def decode(opcode, bytes, index)
      d = direction(bytes, index)
      w = width(bytes, index)

      mcode = mod_code(bytes, index + 1)
      rcode = reg_code(bytes, index + 1)
      rmcode = rm_code(bytes, index + 1)

      rtype = register_type(w)
      eaddress = effective_address(mcode, w)

      source = d.zero? ? rtype[rcode] : eaddress[rmcode]
      destination = d.zero? ? eaddress[rmcode] : rtype[rcode]
      case mcode
      when 0b00
        if rmcode == 0b110
          data = format(bytes[index + 2])
          source = "#{data}"
        end
        d.zero? ? destination = "[#{destination}]" : source = "[#{source}]"
      when 0b01..0b10
        output = displacement(bytes, index + 2, mcode)

        output = output.to_s(16)
        output = output.index('-') ? output.insert(1, '0x') : output.insert(0, '+0x')
        d.zero? ? destination = "[#{destination}#{output}]" : source = "[#{source}#{output}]"
      when 0b11
        # no additional processing needed
      end
      instruct = "#{opcode} #{destination},#{source}"
      inc = increment(mcode, rmcode, w)
      # byebug
      [instruct, inc]
    end
  end
end

module MemoryToOrFromAccumulator
  class << self
    def increment(width)
      width == 0 ? 2 : 3
    end

    def decode(opcode, bytes, index)
      # to be implemented
      d = direction(bytes, index)
      w = width(bytes, index)
      data = get_data(bytes, index + 1, w)

      destination = d.zero? ? 'ax' : "[#{data}]"
      source = d.zero? ? "[#{data}]" : 'ax'
      instruct = "#{opcode} #{destination},#{source}"
      inc = increment(w)
      # byebug
      [instruct, inc]
    end
  end
end

module RegisterOrMemoryToOrFromSegmentRegister
  class << self
    def get_sr(bytes, index)
      # mod 0 sr r/m
      bytes[index] >> 3 & 0b11
    end

    def effective_address(mod_code)
      case mod_code
      when 0b00
        EFFECTIVE_ADDRESS_MODE_00
      when 0b01
        EFFECTIVE_ADDRESS_MODE_01
      when 0b10
        EFFECTIVE_ADDRESS_MODE_10
      when 0b11
        SIXTEEN_BIT_REGISTERS
      end
    end

    def increment(mod_code)
      case mod_code
      in 0b00
        2
      in 0b01
        3
      in 0b10
        4
      in 0b11
        2
      end
    end

    def decode(opcode, bytes, index)
      # to be implemented
      d = direction(bytes, index)

      srcode = get_sr(bytes, index + 1)
      rmcode = rm_code(bytes, index + 1)
      mcode = mod_code(bytes, index + 1)
      eaddress = effective_address(mcode)

      destination = d.zero? ? eaddress[rmcode] : SR[srcode]
      source = d.zero? ? SR[srcode] : eaddress[rmcode]

      case mcode
      in 0b00
        d.zero? ? destination = "[#{destination}]" : source = "[#{source}]"
      in 0b01..0b10
        disp = displacement(bytes, index + 2, mcode)
        if d.zero?
          destination = "[#{destination} + #{disp}]"
        else
          source = "[#{source} + #{disp}]"
        end
      in 0b11
        # no additional processing needed
      end

      instruct = "#{opcode} #{destination},#{source}"
      inc = increment(mcode)
      [instruct, inc]
    end
  end
end

binary_file = ARGV[0]
binary_file ||= './asm/register_movs'

bytes = File.binread(binary_file).bytes
index = 0
output = ''

while index < bytes.length
  case bytes[index]
  when 0b10110000..0b10111111
    instruction, idx = ImmediateToRegister.decode('mov', bytes, index)
  when 0b100010..0b10001011
    instruction, idx = RegisterOrMemoryToOrFromRegister.decode('mov', bytes, index)
  when 0b10100000..0b10100011
    instruction, idx = MemoryToOrFromAccumulator.decode('mov', bytes, index)
  when 0b10001110, 0b10001100
    instruction, idx = RegisterOrMemoryToOrFromSegmentRegister.decode('mov', bytes, index)
  when 0b000000..0b00000011
    instruction, idx = RegisterOrMemoryToOrFromRegister.decode('add', bytes, index)
  when 0b0..0o11111111
    puts "#{bytes[index].to_s(2).rjust(8, '0')} not implemented"
    break
  end

  output += instruction + "\n"
  index += idx
end

puts output
