# frozen_string_literal: true

class ApplyPromotionalRuleLogic
  def initialize(promotional_rule, total:, products:)
    @promotional_rule = promotional_rule
    @total = total
    @products = products
  end

  def discount_value
    if promotional_rule.target_type == 'order'
      calculate_order_discount(promotional_rule)
    elsif promotional_rule.target_type == 'product'
      calculate_product_discount(promotional_rule)
    end
  end

  private

  attr_reader :promotional_rule, :total, :products

  def calculate_order_discount(rule)
    case rule.condition_type
    when 'total_is_more_than'
      if total > rule.condition_value
        discount_order_price(rule.discount_value_type, rule.discount_value)
      end
    end
  end

  def calculate_product_discount(rule)
    case rule.condition_type
    when 'count_is_more_than'
      if products.select { |p| p == rule.target }.size > rule.condition_value
        discount_product_price(rule.discount_value_type, rule.discount_value)
      end
    end
  end

  def discount_order_price(value_type, value)
    total * (BigDecimal(value) / BigDecimal(100)) if value_type == 'percent'
  end

  def discount_product_price(value_type, value)
    products.select { |p| p == promotional_rule.target }.map do |_product|
      BigDecimal(value, 3) if value_type == 'price'
    end.compact.sum
  end
end
