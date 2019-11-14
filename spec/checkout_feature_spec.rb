require_relative '../lib/checkout'
require_relative '../lib/item'

describe 'Checkout' do
  context 'when there are no promotional rules' do
    it 'returns £0.00 when no items are scanned' do
      co = Checkout.new

      expect(co.total).to eq '£0.00'
    end

    it 'returns the combined total when given three items' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)
      item3 = Item.new('003', 'Funky light', 1995)

      co = Checkout.new
      co.scan(item1)
      co.scan(item2)
      co.scan(item3)

      expect(co.total).to eq '£74.20'
    end
  end

  context 'when there is a 10% percentage off total promotional rule' do
    it 'returns the total with 10% taken off' do
      item1 = Item.new('001', 'Very Cheap Chair', 925)
      item2 = Item.new('002', 'Little table', 4500)
      item3 = Item.new('003', 'Funky light', 1995)
      promotional_rules = [{ type: 'percentage_off_basket', eligible_amount: 6000, percantage: 10 }]

      co = Checkout.new(promotional_rules)
      co.scan(item1)
      co.scan(item2)
      co.scan(item3)

      expect(co.total).to eq '£66.78'
    end
  end
end
