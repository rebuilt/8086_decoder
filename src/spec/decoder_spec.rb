require 'rspec/autorun'

RSpec.describe 'Decoder output' do
  it 'matches the output of ndisasm for many register movs' do
    ndisasm_output = `ndisasm -b 16 many_register_movs`
    ruby_output = `ruby decoder.rb many_register_movs`

    expect(ruby_output).to eq(ndisasm_output)
  end

  it 'matches the ouput for immediate to register movs' do
    ndisasm_output = `ndisasm -b 16 immediate_to_register_movs`
    ruby_output = `ruby decoder.rb immediate_to_register_movs`

    expect(ruby_output).to eq(ndisasm_output)
  end
end
