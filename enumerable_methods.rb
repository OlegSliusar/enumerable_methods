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
end
