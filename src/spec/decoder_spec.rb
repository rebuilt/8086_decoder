require_relative '../decoder'

RSpec.describe '#decode', :model do
  it 'matches the output of ndisasm for many register movs' do
    filename = 'many_register_movs'
    ndisasm_output = `ndisasm -b 16 #{filename}`
    instructions = ndisasm_output.split("\n").map { |line| line.split(' ')[2..].join(' ') + "\n" }.join
    ruby_output = `ruby decoder.rb #{filename}`

    expect(ruby_output).to eq(instructions)
  end

  it 'matches the ouput for immediate to register movs' do
    filename = 'immediate_to_register'
    ndisasm_output = `ndisasm -b 16 #{filename}`
    instructions = ndisasm_output.split("\n").map { |line| line.split(' ')[2..].join(' ') + "\n" }.join

    ruby_output = `ruby decoder.rb #{filename}`

    expect(ruby_output).to eq(instructions)
  end
end
