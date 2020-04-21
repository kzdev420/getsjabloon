class CreatePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :sjabloon_policies do |t|
      t.string :policy_type, null: false
      t.string :title, null: false
      t.boolean :mandatory, default: false
      t.text :content

      t.timestamps
    end
  end
end

