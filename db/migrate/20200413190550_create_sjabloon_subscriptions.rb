class CreateSjabloonSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :sjabloon_subscriptions do |t|
      t.references :owner
      t.string :name, null: false
      t.string :processor, null: false
      t.string :processor_id, null: false
      t.string :processor_plan, null: false
      t.integer :quantity, default: 1, null: false
      t.datetime :trial_ends_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end

