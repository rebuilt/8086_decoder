require_relative '../decoder'

RSpec.describe '#decode', :model do
  it 'matches the output of ndisasm for many register movs' do
    filename = 'many_register_movs'
    compare_output(filename)
  end

  it 'matches the output for immediate to register movs' do
    filename = 'immediate_to_register'
    compare_output(filename)
  end

  it 'matches the output for register movs' do
    filename = 'register_movs'
    compare_output(filename)
  end

  # it 'matches the output for add sub cmp instructions' do
  #   filename = 'add_sub_cmp'
  #   compare_output(filename)
  # end
  it 'matches the output for source address calculations' do
    filename = 'source_address_calculation'
    compare_output(filename)
  end

  # it 'matches the output for challenge movs' do
  #   filename = 'challenge_movs'
  #   compare_output(filename)
  # end

  it 'matches the output for memory to accumulator' do
    filename = 'memory_to_accumulator'
    compare_output(filename)
  end
end

def compare_output(filename)
  ndisasm_output = `ndisasm -b 16 ./asm/#{filename}`
  instructions = ndisasm_output.split("\n").map { |line| line.split(' ')[2..].join(' ') + "\n" }.join

  ruby_output = `ruby decoder.rb ./asm/#{filename}`

  expect(ruby_output).to eq(instructions)
end
