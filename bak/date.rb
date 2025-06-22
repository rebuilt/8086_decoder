# frozen_string_literal: true

require 'byebug'
require 'benchmark'
# https://www.58bits.com/blog/bitmask-and-bitwise-operations-in-ruby
# https://www.webascender.com/blog/working-bits-bytes-ruby/
bits = 0b0000000000000000

YEAR_MASK  = 0b1111111000000000
MONTH_MASK = 0b0000000111100000
DAY_MASK   = 0b0000000000011111

ZERO_YEAR_MASK  = 0b0000000111111111
ZERO_MONTH_MASK = 0b1111111000011111
ZERO_DAY_MASK   = 0b1111111111100000

def year(bits)
  ((bits & YEAR_MASK) >> 9) + 2000
end

def month(bits)
  (bits & MONTH_MASK) >> 5
end

def day(bits)
  bits & DAY_MASK
end

def set_year(bits, year)
  (bits & ZERO_YEAR_MASK) | (year << 9)
end

def set_month(bits, month)
  (bits & ZERO_MONTH_MASK) | (month << 5)
end

def set_day(bits, day)
  (bits & ZERO_DAY_MASK) | day
end

def pp(bits)
  if bits.to_s(2).length < 10
    puts bits.to_s(2)
  else
    puts bits.to_s(2).insert(-10, ' ').insert(-6, ' ')
  end
end

def formatted_date(bits)
  "#{year(bits)}/#{month(bits)}/#{day(bits)}"
end

pp bits

bits = set_year(bits, 25)
puts "Year: #{year(bits)}"
pp bits

bits = set_month(bits, 6)
puts "Month: #{month(bits)}"
pp bits

bits = set_day(bits, 15)
puts "Day: #{day(bits)}"
pp bits
puts formatted_date(bits)

def iterate_dates(iterations)
  # Generate dates from 2000 to 2127, for each month and each day of the month
  # This will create a total of 100 * 31 * 12 * 128 = 4,761,600 dates
  iterations.times do
    (2000..2127).each do |year|
      (1..12).each do |month|
        (1..31).each do |day|
          yield year, month, day
        end
      end
    end
  end
end

def create_binary_file
  dates = []
  iterate_dates(1) do |year, month, day|
    bits = 0b0000000000000000
    bits = set_year(bits, year - 2000)
    bits = set_month(bits, month)
    bits = set_day(bits, day)
    dates << bits
  end
  File.open 'dates.bin', 'wb' do |file|
    file.write(dates.pack('S>*'))
  end
end

def create_text_file
  dates = []

  iterate_dates(1) do |year, month, day|
    dates << "#{year}/#{month}/#{day}"
  end

  File.open 'dates.txt', 'w' do |file|
    file.write(dates.join("\n"))
  end
end

p [:binary, Benchmark.realtime { create_binary_file }.round(2)]
p [:text, Benchmark.realtime { create_text_file }.round(2)]

File.open 'dates.bin', 'rb' do |file|
  unpacked_dates = file.read.unpack('S>*').first(10)
  unpacked_dates.each do |date_bits|
    puts formatted_date(date_bits)
  end
end
