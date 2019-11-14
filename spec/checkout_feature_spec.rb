# frozen_string_literal: true

require_relative '../lib/checkout'
require_relative '../lib/item'

describe 'Checkout Feature' do
  subject { co.total }

  let(:item1)       { Item.new('001', 'Very Cheap Chair', 925) }
  let(:item2)       { Item.new('002', 'Little table', 4500) }
  let(:item3)       { Item.new('003', 'Funky light', 1995) }
  let(:co)          { Checkout.new(promotional_rules: promotional_rules) }
  let(:promo1) do
    Promotion::PercentageOff.new(
      type: :percentage_off,
      eligible_min_amount: 6000,
      percentage: 10,
      priority: 1
    )
  end

  let(:promo2) do
    Promotion::MultiItem.new(
      type: :multi_item,
      eligible_min_quantity: 2,
      item_code: '001',
      discounted_price: 850,
      priority: 0
    )
  end

  context 'when there are no promotional rules' do
    let(:promotional_rules) { [] }

    it 'returns £0.00 when there are no items in basket' do
      is_expected.to eq '£0.00'
    end

    it 'returns the combined total when given three items' do
      co.scan(item1)
      co.scan(item2)
      co.scan(item3)

      is_expected.to eq '£74.20'
    end
  end

  context 'when there is a 10% percentage off total promotional rule' do
    let(:promotional_rules) { [promo1] }

    it 'returns the total with 10% taken off' do
      co.scan(item1)
      co.scan(item2)
      co.scan(item3)

      is_expected.to eq '£66.78'
    end
  end

  context 'when there is a multiple item promotion' do
    let(:promotional_rules) { [promo2] }

    it 'returns the combined total with the reduced prices' do
      co.scan(item1)
      co.scan(item1)

      is_expected.to eq '£17.00'
    end
  end

  context 'when there is a multiple item and a percentage off promotion' do
    let(:promotional_rules) { [promo1, promo2] }

    it 'returns the combined total with both promotional_rules applied (multi_item first)' do
      co.scan(item1)
      co.scan(item2)
      co.scan(item1)
      co.scan(item3)

      is_expected.to eq '£73.76'
    end

    context 'with different priorities, amounts and order_items in promotional_rules' do
      let(:promotional_rules) do
        [
          Promotion::PercentageOff.new(
            type: 'percentage_off_basket',
            eligible_min_amount: 4500,
            percentage: 1,
            priority: 0
          ),
          Promotion::MultiItem.new(
            type: 'multi_item',
            eligible_min_quantity: 3,
            item_code: '003',
            discounted_price: 500,
            priority: 1
          ),
        ]
      end

      it 'works with different priorities, amounts and order_items in promotional_rules' do
        item1 = Item.new('001', 'Very Cheap Chair', 100)
        item2 = Item.new('002', 'Little table', 2500)
        item3 = Item.new('003', 'Funky light', 1000)

        co.scan(item1)
        co.scan(item2)
        co.scan(item3)
        co.scan(item3)
        co.scan(item3)

        is_expected.to eq '£40.74'
      end
    end
  end
end
