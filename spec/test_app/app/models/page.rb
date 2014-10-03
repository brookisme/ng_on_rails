class Page < ActiveRecord::Base
  default_scope { order(order_index: :asc) }
  belongs_to :doc
end
