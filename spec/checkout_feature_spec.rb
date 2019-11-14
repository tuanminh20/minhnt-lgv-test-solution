require_relative '../lib/checkout'

describe 'Checkout' do
  context 'when there are no promotional rules' do
    it '#total returns £0.00 when no items are scanned' do
      co = Checkout.new

      expect(co.total).to eq '£0.00'
    end
  end
end
