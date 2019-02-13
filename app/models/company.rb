class Company < ApplicationRecord
  enum type_iva: { ex: 0 , mt: 1 , ri: 2 }

  has_many :documents, dependent: :restrict_with_error
  has_many :point_sales, dependent: :destroy

  def unformat_cuit
    Legal::unformat_cuit(self.cuit)
  end
end
