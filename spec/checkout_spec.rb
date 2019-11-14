require_relative '../lib/checkout'
require_relative '../lib/item'

describe 'Checkout' do
  describe '#total' do
    it 'returns £0.00 when no items have been scanned' do
      co = Checkout.new

      expect(co.total).to eq '£0.00'
    end

    it 'returns the combined price when two items have been scanned' do
      item = Item.new('003', 'Funky light', 1995)

      co = Checkout.new
      co.scan(item)
      co.scan(item)

      expect(co.total).to eq '£39.90'
    end

    it 'returns the combined price - 10%, with promo rule and eligibility is met' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)
      item3 = Item.new('003', 'Funky light', 1995)
      promotional_rules = [{
        type: 'percentage_off_basket',
        eligible_min_amount: 6000,
        percentage: 10,
      },]

      co = Checkout.new(promotional_rules: promotional_rules)
      co.scan(item1)
      co.scan(item2)
      co.scan(item3)

      expect(co.total).to eq '£66.78'
    end

    it 'returns the standard combined price, with promo rule and eligibility is not met' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)
      promotional_rules = [{
        type: 'percentage_off_basket',
        eligible_min_amount: 6000,
        percentage: 10,
      },]

      co = Checkout.new(promotional_rules: promotional_rules)
      co.scan(item1)
      co.scan(item2)

      expect(co.total).to eq '£54.25'
    end

    it 'returns the combined total with reduced prices, when multi_item_promo eligibility is met' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)

      promotional_rules = [{
        type: 'multi_item',
        eligible_min_quantity: 2,
        item_code: '001',
        reduced_price: 850,
      },]

      co = Checkout.new(promotional_rules: promotional_rules)
      co.scan(item1)
      co.scan(item1)

      expect(co.total).to eq '£17.00'
    end

    it 'returns the standard combined total, when multi_item_promo eligibility is not met' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)

      promotional_rules = [{
        type: 'multi_item',
        eligible_min_quantity: 2,
        item_code: '001',
        reduced_price: 850,
      },]

      co = Checkout.new(promotional_rules: promotional_rules)
      co.scan(item1)
      co.scan(item2)

      expect(co.total).to eq '£54.25'
    end

    it 'returns the combined total with both promotions applied' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)
      item3 = Item.new('003', 'Funky light', 1995)

      promotional_rules = [
        {
          type: 'multi_item',
          eligible_min_quantity: 2,
          item_code: '001',
          reduced_price: 850,
          priority: 0,
        }, {
          type: 'percentage_off_basket',
          eligible_min_amount: 6000,
          percentage: 10,
          priority: 1,
        },
      ]

      co = Checkout.new(promotional_rules: promotional_rules)
      co.scan(item1)
      co.scan(item2)
      co.scan(item1)
      co.scan(item3)

      expect(co.total).to eq '£73.76'
    end

    it 'returns combined total with both promotions applied (multi_item_first)' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)
      item3 = Item.new('003', 'Funky light', 1995)

      promotional_rules = [
        {
          type: 'percentage_off_basket',
          eligible_min_amount: 6000,
          percentage: 10,
          priority: 1,
        }, {
          type: 'multi_item',
          eligible_min_quantity: 2,
          item_code: '001',
          reduced_price: 850,
          priority: 0,
        },
      ]

      co = Checkout.new(promotional_rules: promotional_rules)
      co.scan(item1)
      co.scan(item2)
      co.scan(item1)
      co.scan(item3)

      expect(co.total).to eq '£73.76'
    end
  end
end
