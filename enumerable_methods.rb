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
end
