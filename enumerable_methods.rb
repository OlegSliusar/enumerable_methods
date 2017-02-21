module Enumerable
  def my_each
    self.length.times do |index|
      yield(self[index])
    end
  end
end
