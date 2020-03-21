# frozen_string_literal: true

require_relative '../logics/apply_promotional_rule_logic'

class Checkout
  attr_reader :products
  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
    @products = []
  end

  def scan(product)
    @products.push(product)
  end

  def total
    total_without_discounts - discount.round(2, :half_down)
  end

  def total_without_discounts
    @products.map(&:price).map(&:to_f).sum
  end

  def discount
    products_discounts + order_discounts
  end

  def order_discounts
    product_promotional_rules = @promotional_rules.select do |pr|
      pr.target_type == 'order'
    end

    apply_promotional_rules(
      @products,
      product_promotional_rules,
      total_without_discounts - products_discounts
    )
  end

  def products_discounts
    product_promotional_rules = @promotional_rules.select do |pr|
      pr.target_type == 'product'
    end

    apply_promotional_rules(
      @products,
      product_promotional_rules,
      total_without_discounts
    )
  end

  def apply_promotional_rules(products, promotional_rules, total)
    promotional_rules.map do |promotional_rule|
      ApplyPromotionalRuleLogic.new(
        promotional_rule,
        total: total,
        products: products
      ).discount_value
    end.compact.sum.to_d
  end
end
