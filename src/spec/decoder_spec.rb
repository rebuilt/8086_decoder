require 'rspec/autorun'

RSpec.describe 'Decoder output' do
  it 'matches the output of ndisasm' do
    ndisasm_output = `ndisasm -b 16 many_register_movs`
    ruby_output = `ruby decoder.rb`

    expect(ruby_output).to eq(ndisasm_output)
  end
end
