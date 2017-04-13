require_relative '../enumerable_methods'

describe Enumerable do
  describe '#multiply_els' do
    it 'returns the right value' do
      expect([1, 2, 3, 4].multiply_els).to eq(24)
    end
  end
end
