require_relative '../lib/checkout'
require_relative '../lib/item'

describe 'Checkout' do
  let(:discounter) { double(:discounter) }
  let(:discounter_instance) { double(:discounter_instance) }

  before(:each) do
    allow(discounter).to receive(:new).and_return(discounter_instance)
  end

  describe '#total' do
    it 'returns £0.00 when discounter returns []' do
      allow(discounter_instance).to receive(:discounted_basket).and_return([])

      co = Checkout.new(discounter: discounter)

      expect(co.total).to eq '£0.00'
    end

    it 'returns formatted total of discounted_prices from basket returned by discounter' do
      discounted_item1 = OrderItem.new('001', 'Very Cheap Chair', 925, 832)
      discounted_item2 = OrderItem.new('002', 'Little table', 4500, 4050)
      discounted_item3 = OrderItem.new('003', 'Funky light', 1995, 1796)
      discounted_basket = [discounted_item1, discounted_item2, discounted_item3]
      allow(discounter_instance).to receive(:discounted_basket).and_return(discounted_basket)

      co = Checkout.new(discounter: discounter)

      expect(co.total).to eq '£66.78'
    end
  end
end
