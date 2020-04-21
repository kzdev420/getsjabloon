class CreateSjabloonPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :sjabloon_plans do |t|
      t.string :processor_id
      t.integer :amount
      t.string :currency
      t.string :nickname
      t.integer :trial_period_days
      t.string :interval
      t.string :interval_count
      t.string :product
      t.jsonb :features, null: false, default: {}
      t.integer :position
      t.boolean :active, default: true
      t.boolean :visible, default: true

      t.timestamps
    end
  end
end

