# frozen_string_literal: true

require_relative '../lib/promotion/multi_item'
require_relative '../lib/checkout'

describe Promotion::MultiItem do
  subject { promo_rule.discounted_basket(basket) }

  let(:chair1) { OrderItem.new('001', 'Very Cheap Chair', 925, 850) }
  let(:chair2) { OrderItem.new('001', 'Very Cheap Chair', 925, 850) }
  let(:table1) { OrderItem.new('002', 'Little table', 4500, 4500) }
  let(:discounted_chair) { OrderItem.new('001', 'Very Cheap Chair', 925, 850) }
  let(:promo_rule) do
    described_class.new(type: 'multi_item',
                        eligible_min_quantity: 2,
                        item_code: '001',
                        discounted_price: 850)
  end

  context 'when it has more than x associated items' do
    let(:basket) { [chair1, chair2] }
    let(:expected_basket) { [discounted_chair, discounted_chair] }

    it 'returns discounted basket' do
      is_expected.to eq expected_basket
    end
  end

  context 'when it has more than x associated items and other items' do
    let(:basket) { [chair1, chair2, table1] }
    let(:expected_basket) { [discounted_chair, discounted_chair, table1] }

    it 'returns discounted basket' do
      is_expected.to eq expected_basket
    end
  end

  context 'when it is not eligible' do
    let(:basket) { [chair1, table1] }

    it 'returns the original basket' do
      is_expected.to eq basket
    end
  end
end
