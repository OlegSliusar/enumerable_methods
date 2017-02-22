module Enumerable
  def my_each
    self.length.times do |index|
      yield(self[index])
    end
  end

  def my_each_with_index
    self.length.times do |index|
      yield(self[index], index)
    end
  end

  def my_select
    result = []
    self.my_each do |element|
      result << element if yield(element) == true
    end
    result
  end

  def my_all?
    result = true
    self.my_each do |element|
      result = false if yield(element) == false
    end
    result
  end

  def my_any?
    result = false
    self.my_each do |element|
      result = true if yield(element) == true
    end
    result
  end

  def my_none?
    result = true
    self.my_each do |element|
      result = false if yield(element) == true
    end
    result
  end

  def my_count(item = nil)
    counter = 0
    if item.nil? && !block_given?
      until self[counter].nil?
        counter += 1
      end
      counter
    elsif item && !block_given?
      self.my_each do |element|
        counter += 1 if element == item
      end
      counter
    elsif block_given?
      self.my_each do |element|
        counter += 1 if yield(element) == true
      end
      counter
    end
  end

  def my_map(block)
    self.my_each_with_index do |item, index|
      self[index] = block.call(item)
    end
    self
  end

  def my_inject(arg = nil, arg2 = nil)
    if !arg.nil? && !(Symbol === arg)
      memo = arg
    end
    memo = 0
    memo = 1 if arg == :*
    if Symbol === arg
      self.my_each_with_index do |element, index|
        memo = self[0] if index == 0
        memo = memo.send arg, self[index + 1] unless self[index + 1].nil?
      end
      memo
    elsif Symbol === arg2
      memo = arg
      self.my_each do |element|
        memo = memo.send arg2, element
      end
      memo
    elsif !arg.nil? && arg2.nil? && block_given?
      memo = arg
      self.my_each do |element|
        memo = yield(memo, element)
      end
      memo
    else
      memo = 0
      self.my_each_with_index do |element, index|
        memo = self[0] if index == 0
        memo = yield(memo, element)
      end
      memo
    end
  end

  def multiply_els(ary = nil)
    return ary.my_inject(:*) unless ary.nil?
    self.my_inject(:*)
  end
end

def multiply_els(ary)
  ary.my_inject(:*)
end

some_block = Proc.new { |i| i * i }

p "[1, 2, 3, 4].my_map(some_block) => #{[1, 2, 3, 4].my_map(some_block)}, should be [1, 4, 9, 16]"
# p "[1, 2, 3, 4].my_map { |i| i*i } => #{[1, 2, 3, 4].my_map { |i| i*i }}, should be [1, 4, 9, 16]"   #=> [1, 4, 9, 16]

p "[5, 6, 7, 8, 9, 10].my_inject { |sum, n| sum + n }    => #{[5, 6, 7, 8, 9, 10].my_inject { |sum, n| sum + n }}, should be 45"   #=> 45

p "[5, 6, 7, 8, 9, 10].my_inject(:+)   => #{[5, 6, 7, 8, 9, 10].my_inject(:+)}, should be 45"    # => 45

p "[10, 2, 4].my_inject(:-)    => #{[10, 2, 4].my_inject(:-)}, should be 4"    # => 4

p "[8, 2, 2].my_inject(:/)    => #{[8, 2, 2].my_inject(:/)}, should be 2"   # => 2

p "[1, 2, 3, 4].my_inject(:*)   => #{[1, 2, 3, 4].my_inject(:*)}, should be 24"    # => 24

p "[5, 6, 7, 8, 9, 10].my_inject(1, :*)    => #{[5, 6, 7, 8, 9, 10].my_inject(1, :*)}, should be 151200"    # => 151200

p "[5, 6, 7, 8, 9, 10].my_inject(1) { |product, n| product * n }   => #{[5, 6, 7, 8, 9, 10].my_inject(1) { |product, n| product * n }}, should be 151200" #=> 151200

longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
p "The longest word is '#{longest}', should be 'sheep'"

p "[1, 2, 3, 4].multiply_els => #{[1, 2, 3, 4].multiply_els}, should be 24"   # => 24
p "multiply_els([2,4,5]) => #{multiply_els([2,4,5])}, should be 40"    #=> 40
