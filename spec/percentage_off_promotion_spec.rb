require_relative '../lib/percentage_off_promotion'
require_relative '../lib/item'

describe PercentageOffPromotion do
  it 'deducts 10% when it exceeds the eligibility of the rule' do
    promotional_rule = { type: 'percentage_off_basket', eligible_min_amount: 6000, percentage: 10 }

    percentage_off_promo = PercentageOffPromotion.new(promotional_rule, 7000)

    expect(percentage_off_promo.apply).to eq 6300
  end

  it 'deducts 10% when it meets exactly the eligibility of the rule' do
    promotional_rule = { type: 'percentage_off_basket', eligible_min_amount: 6000, percentage: 10 }

    percentage_off_promo = PercentageOffPromotion.new(promotional_rule, 6000)

    expect(percentage_off_promo.apply).to eq 5400
  end

  it 'returns the original amount when it meets exactly the eligibility of the rule' do
    promotional_rule = { type: 'percentage_off_basket', eligible_min_amount: 6000, percentage: 10 }
    original_amount = 5252
    percentage_off_promo = PercentageOffPromotion.new(promotional_rule, original_amount)

    expect(percentage_off_promo.apply).to eq original_amount
  end
end
