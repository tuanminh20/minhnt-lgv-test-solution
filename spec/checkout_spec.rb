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
  end
end
