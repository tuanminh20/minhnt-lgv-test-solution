# frozen_string_literal: true

require_relative '../lib/discounter'
require_relative '../lib/order_item'

describe Discounter do
  subject(:discounter) do
    described_class.new(promotional_rules: promotional_rules, basket: basket).discounted_basket
  end

  let(:chair1) { OrderItem.new('001', 'Very Cheap Chair', 925, 925) }
  let(:chair2) { OrderItem.new('001', 'Very Cheap Chair', 925, 925) }
  let(:table1) { OrderItem.new('002', 'Little table', 4500, 4500) }

  context 'when there are no discounts to apply' do
    let(:promotional_rules) { [] }
    let(:basket) { [chair1, chair2, table1] }

    it 'returns the original basket' do
      is_expected.to eq basket
    end
  end
end
