# frozen_string_literal: true

require_relative './promotion/base'
require_relative './promotion/multi_item'
require_relative './promotion/percentage_off'

class Discounter
  # should be defined elsewhere
  PROMO_DEFAULT_HANDLER = {
    percentage_off: Promotion::PercentageOff,
    multi_item: Promotion::MultiItem,
  }.freeze

  def initialize(
    promotional_rules: [],
    basket: [],
    options: {}
  )
    @promotional_rules = promotional_rules
    @basket = basket
    @options = options
  end

  def discounted_basket
    prioritised_promo_rules.inject(@basket) do |basket, promotion|
      promotion.discounted_basket(basket)
    end
  end

  private

  def prioritised_promo_rules
    @promotional_rules.sort_by { |promotion| promotion.promo_rule[:priority] }
  end

  def promo_klass(promotion)
    promo_type = promotion.promo_rule[:type].to_sym
    @options[promo_type] || PROMO_DEFAULT_HANDLER[promo_type]
    # should raise an error if can not find class
  end
end
