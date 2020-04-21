class CreateSjabloonCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :sjabloon_coupons do |t|
      t.string :code
      t.string :name
      t.string :currency
      t.integer :max_redemptions
      t.integer :amount_off
      t.decimal :percent_off
      t.string :duration
      t.integer :duration_in_months
      t.timestamp :redeem_by
      t.integer :times_redeemed, default: 0
      t.boolean :is_valid

      t.timestamps
    end
  end
end

