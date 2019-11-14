require_relative '../lib/discounter'

describe Discounter do
  let(:percentage_off_promotion) { double(:percentage_off_promotion) }
  let(:percentage_off_promotion_instance) { double(:percentage_off_promotion_instance) }
  let(:multi_item_promotion) { double(:multi_item_promotion) }
  let(:multi_item_promotion_instance) { double(:multi_item_promotion_instance) }

  it 'returns the total when there are no discounts to apply' do
    item1 = Item.new('001', 'Very Cheap Chair', 925)
    item2 = Item.new('002', 'Little table', 4500)
    promotional_rules = []
    basket = [item1, item1, item2]

    discounter = Discounter.new(
      promotional_rules: promotional_rules,
      basket: basket,
      percentage_off_promotion_klass: percentage_off_promotion,
      multi_item_promotion_klass: multi_item_promotion
    )

    expect(discounter.apply).to eq 6350
  end

  it 'with two promo_rules, it calls the second priority with result of first priority' do
    item1 = Item.new('001', 'Very Cheap Chair', 925)
    item2 = Item.new('002', 'Little table', 4500)
    item3 = Item.new('003', 'Funky light', 1995)

    percentage_off_rule = {
      type: 'percentage_off_basket',
      eligible_min_amount: 6000,
      percentage: 10,
      priority: 1,
    }
    multi_item_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      reduced_price: 850,
      priority: 0,
    }
    promotional_rules = [percentage_off_rule, multi_item_rule]
    basket = [item1, item2, item1, item3]

    discounter = Discounter.new(
      promotional_rules: promotional_rules,
      basket: basket,
      percentage_off_promotion_klass: percentage_off_promotion,
      multi_item_promotion_klass: multi_item_promotion
    )

    mip_response = 5
    pop_response = 10

    allow(multi_item_promotion).to receive(:new).and_return(multi_item_promotion_instance)
    allow(multi_item_promotion_instance).to receive(:apply).and_return(mip_response)
    allow(percentage_off_promotion).to receive(:new).and_return(percentage_off_promotion_instance)
    allow(percentage_off_promotion_instance).to receive(:apply).and_return(pop_response)

    expect(percentage_off_promotion).to receive(:new).with(percentage_off_rule, mip_response)

    discounter.apply
  end
end
