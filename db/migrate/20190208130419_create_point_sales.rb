class CreatePointSales < ActiveRecord::Migration[5.2]
  def change
    create_table :point_sales do |t|
      t.integer  "company_id"
      t.integer  "pos_number",    default: 0
      t.integer  "concept",       default: 0,  null: false
      t.integer  "fiscal_type",   default: 1,  null: false

      t.timestamps
    end
  end
end
