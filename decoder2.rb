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

# first byte    | second byte | third byte
# 1 0 1 1 w reg | data        | data if w == 1

module ImmediateToRegister
  def self.get_opcode(bytes, index)
    opcode = ''
    case bytes[index]
    # 1 0 1 1 w reg
    when 0b10110000..0b10111111
      opcode = 'mov'
    end
    opcode
  end

  def self.get_width(bytes, index)
    # 1 0 1 1 w reg
    # (bytes[index] >> 3)  & 0b1
    (bytes[index] & 0b00001000) >> 3
  end

  def self.get_reg(bytes, index, w)
    # 1 0 1 1 w reg
    register_code = bytes[index] & 0b111
    register_type = w == 0 ? EIGHT_BIT_REGISTERS : SIXTEEN_BIT_REGISTERS
    register_type[register_code]
  end

  def self.get_data(bytes, index, w)
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

  def self.decode(bytes, index)
    opcode = get_opcode(bytes, index)
    w = get_width(bytes, index)
    reg = get_reg(bytes, index, w)
    data = get_data(bytes, index + 1, w)
    output = "#{opcode} #{reg}, #{data}"
    increment = w == 0 ? 2 : 3
    [output, increment]
  end
end

# first byte | second byte | third byte | fourth byte
# 100010 d w | mod reg r/m | (DISP-LO)  | (DISP-HI)

module RegisterOrMemoryToOrFromRegister
  def self.opcode(bytes, index)
    case bytes[index]
    when 0b10001000..0b10001011 # Register/memory to/from register
      'mov'
    end
  end

  def self.direction(bytes, index)
    # Extract destination from bytes at given index
    # 100010 d w
    (bytes[index] >> 1) & 0b1
  end

  def self.width(bytes, index)
    # 100010 d w
    bytes[index] & 0b1
  end

  def self.mod_code(bytes, index)
    # mod reg r/m
    bytes[index] >> 6
  end

  def self.reg_code(bytes, index)
    # mod reg r/m
    bytes[index] >> 3 & 0b111
  end

  def self.rm_code(bytes, index)
    # mod reg r/m
    bytes[index] & 0b111
  end

  def self.register_type(w)
    if w.zero?
      EIGHT_BIT_REGISTERS
    else
      SIXTEEN_BIT_REGISTERS
    end
  end

  def self.effective_address(mod_code, w)
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

  def self.instruction(opcode, destination, source, displacement)
    "#{opcode} #{destination},#{source} #{displacement}"
  end

  def self.increment(mod_code, rm_code, w)
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

  def self.displacement(bytes, index, width)
    if width == 0
      bytes[index]
    else
      bytes[index + 1] << 8 | bytes[index]
    end
  end

  def self.decode(bytes, index)
    o = opcode(bytes, index)
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
      source = "+0x#{bytes[index + 2].to_s(16)}" if rmcode == 0b110 # Direct address, no displacement
      d.zero? ? destination = "[#{destination}]" : source = "[#{source}]"
    when 0b01..0b10
      disp = displacement(bytes, index + 2, w)
      d.zero? ? destination = "[#{destination} + #{disp}]" : source = "[#{source} + #{disp}]"
    when 0b11
      # no additional processing needed
    end
    instruct = "#{o} #{destination},#{source}"
    inc = increment(mcode, rmcode, w)
    # byebug
    [instruct, inc]
  end
end

binary_file = ARGV[0]
binary_file ||= './asm/register_movs'

bytes = File.binread(binary_file).bytes
puts bytes.length
index = 0
output = ''
while index < bytes.length
  case bytes[index]
  when 0b10110000..0b10111111
    instruction, idx = ImmediateToRegister.decode(bytes, index)
    output += instruction + "\n"
    index += idx
  when 0b100010..0b10001011
    instruction, idx = RegisterOrMemoryToOrFromRegister.decode(bytes, index)
    output += instruction + "\n"
    index += idx
  when 0b0..0o11111111
    puts "#{bytes[index].to_s(2).rjust(8, '0')} not implemented"
    break
  end
end

puts output
