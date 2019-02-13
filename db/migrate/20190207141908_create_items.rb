class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :code
      t.string :description
      t.integer :quantity
      t.integer  :currency_id
      t.decimal :unit_price, precision: 11, scale: 2
      t.decimal :discount,   precision: 11, scale: 2
      t.decimal :iva,        precision: 11, scale: 2
      t.decimal :subtotal,   precision: 11, scale: 2
      t.decimal :margin,     precision: 11, scale: 2
      t.decimal :price_iva,            precision: 11, scale: 2
      t.decimal :normalize_price_cost, precision: 11, scale: 3
      t.decimal :quotation,            precision: 11, scale: 3
      t.integer :product_id
      t.integer :billing_id

      t.timestamps
    end
  end
end
