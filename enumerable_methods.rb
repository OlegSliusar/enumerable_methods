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

  def my_map(proc = Proc.new, &block)
    self.my_each_with_index do |item, index|
      self[index] = proc.call(item)
    end
    self
  end

  def my_inject(arg = nil, arg2 = nil)
    if !arg.nil? && !(Symbol === arg)
      memo = arg
    end

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
      self.my_each_with_index do |element, index|
        memo = self[0] if index == 0
        memo = yield(memo, element)
      end
      memo
    end
  end

  def multiply_els
    self.my_inject(:*)
  end
end
