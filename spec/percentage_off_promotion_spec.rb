# frozen_string_literal: true

require_relative '../lib/promotion/percentage_off'
require_relative '../lib/checkout'

describe Promotion::PercentageOff do
  subject { promo_rule.discounted_basket(basket) }

  let(:chair1) { OrderItem.new('001', 'Very Cheap Chair', 925, 850) }
  let(:chair2) { OrderItem.new('001', 'Very Cheap Chair', 925, 850) }
  let(:table1) { OrderItem.new('002', 'Little table', 4500, 4500) }
  let(:discounted_chair) { OrderItem.new('001', 'Very Cheap Chair', 925, 765) }
  let(:discounted_table) { OrderItem.new('002', 'Little table', 4500, 4050) }
  let(:promo_rule) do
    described_class.new(type: 'percentage_off_basket', eligible_min_amount: 6000, percentage: 10)
  end

  context 'when it exceeds the eligibility of the rule' do
    let(:basket) { [chair1, chair2, table1] }
    let(:expected_basket) do
      [
        discounted_chair,
        discounted_chair,
        discounted_table,
      ]
    end

    it 'deducts 10%' do
      is_expected.to eq expected_basket
    end
  end

  context 'when it meets exactly the eligibility of the rule' do
    let(:fake_item1) { OrderItem.new('001', 'Fake Item', 2000, 2000) }
    let(:fake_item2) { OrderItem.new('001', 'Fake Item', 2000, 2000) }
    let(:fake_item3) { OrderItem.new('001', 'Fake Item', 2000, 2000) }
    let(:discounted_fake_item) { OrderItem.new('001', 'Fake Item', 2000, 1800.0) }
    let(:basket) { [fake_item1, fake_item2, fake_item3] }
    let(:expected_basket) do
      [
        discounted_fake_item,
        discounted_fake_item,
        discounted_fake_item,
      ]
    end

    it 'deducts 10%' do
      is_expected.to eq expected_basket
    end
  end

  context 'when it belows the eligibility of the rule' do
    let(:fake_item1) { OrderItem.new('001', 'Fake Item', 2000, 2000) }
    let(:fake_item2) { OrderItem.new('001', 'Fake Item', 2000, 2000) }
    let(:basket) { [fake_item1, fake_item2] }

    it 'returns the original amount' do
      is_expected.to eq basket
    end
  end
end
