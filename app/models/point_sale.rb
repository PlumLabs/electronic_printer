class PointSale < ApplicationRecord
  enum fiscal_type: { ticketera: 1 , electronic: 2, local: 3 }
  enum concept: { product: 0, service: 1, product_and_service: 2 }

  has_many :documents, dependent: :restrict_with_error

  belongs_to :company
end
