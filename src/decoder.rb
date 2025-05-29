# Define opcode mappings
# pg 558 of https://ia601800.us.archive.org/4/items/The_8086_Book_Russell_Rector_George_Alexy/The_8086_Book_Russell_Rector_George_Alexy.pdf
INSTRUCTION_MAP = {
  [0x89, 0xD9] => 'mov cx, bx'
}

def decode_8086(file_path)
  bytes = File.binread(file_path).bytes
  i = 0

  while i < bytes.length
    if i + 1 < bytes.length
      pair = [bytes[i], bytes[i + 1]]
      if INSTRUCTION_MAP.key?(pair)
        puts "#{format('%04b', i)}: #{pair.map { |b| format('%02b', b) }.join(' ')}  =>  #{INSTRUCTION_MAP[pair]}"
        i += 2
      else
        puts "#{format('%04b', i)}: #{format('%02b', bytes[i])}     =>  Unknown instruction"
        i += 1
      end
    else
      puts "#{format('%04b', i)}: #{format('%02b', bytes[i])}     =>  Incomplete instruction"
      i += 1
    end
  end
end

# Replace with the path to your binary file
binary_file = 'srm'
decode_8086(binary_file)
