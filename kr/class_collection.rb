class Bag
  include Enumerable

  def initialize
    @data = []
  end

  def <<(element)
    @data << element
  end

  def each
    @data.each { |item| yield item }
  end

  def size
    @data.size
  end

  def median
    sorted = self.sort 
    n = sorted.size
    return nil if n.zero?

    if n.odd?
      sorted[n / 2]
    else
      (sorted[n / 2 - 1] + sorted[n / 2]).to_f / 2
    end
  end

  def frequencies
    self.tally 
  end
end

bag = Bag.new
bag << 10 << 20 << 30 << 20 << 10 << 5 << 45

puts "Test Results:"
puts "Size: #{bag.size}" 

puts "Mapped (x*2): #{bag.map { |x| x * 2 }.inspect}"

puts "Frequencies: #{bag.frequencies.inspect}"

puts "Median (odd): #{bag.median}" 

bag << 40
puts "Size: #{bag.size}" 

puts "Median (even): #{bag.median}"
