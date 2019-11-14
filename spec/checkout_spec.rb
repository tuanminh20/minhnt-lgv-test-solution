require_relative '../lib/checkout'

describe 'Checkout' do
  describe '#total' do
    it 'returns £0.00 when no items have been scanned' do
      co = Checkout.new

      expect(co.total).to eq '£0.00'
    end
  end
end