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

  describe '#number_to_currency' do
    it('returns £0.00 for 0') do
      co = Checkout.new

      expect(co.number_to_currency(0)).to eq('£0.00')
    end

    it('returns £1.23 for 123') do
      co = Checkout.new

      expect(co.number_to_currency(123)).to eq('£1.23')
    end

    it('returns £0.01 for 1') do
      co = Checkout.new

      expect(co.number_to_currency(1)).to eq('£0.01')
    end

    it('returns £0.99 for 99') do
      co = Checkout.new

      expect(co.number_to_currency(9999)).to eq('£99.99')
    end
  end
end
