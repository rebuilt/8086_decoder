require_relative '../decoder'

RSpec.describe '#decode', :model do
  it 'matches the output of ndisasm for many register movs' do
    filename = 'many_register_movs'
    compare_output(filename)
  end

  it 'matches the ouput for immediate to register movs' do
    filename = 'immediate_to_register'
    compare_output(filename)
  end
end

def compare_output(filename)
  ndisasm_output = `ndisasm -b 16 ./asm/#{filename}`
  instructions = ndisasm_output.split("\n").map { |line| line.split(' ')[2..].join(' ') + "\n" }.join

  ruby_output = `ruby decoder.rb ./asm/#{filename}`

  expect(ruby_output).to eq(instructions)
end
