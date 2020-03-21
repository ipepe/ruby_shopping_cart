# frozen_string_literal: true

require 'active_hash'
require_relative 'product'

class PromotionalRule < ActiveHash::Base
  self.data = [
    {
      target_type: 'product',
      target: Product.find('001'),

      condition_type: 'count_is_more_than',
      condition_value: 1,

      discount_value: 0.75,
      discount_value_type: 'price'
    },
    {
      target_type: 'order',

      condition_type: 'total_is_more_than',
      condition_value: 60,

      discount_value: 10,
      discount_value_type: 'percent'
    }
  ]
end
