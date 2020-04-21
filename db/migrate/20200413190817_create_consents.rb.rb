class CreateConsents < ActiveRecord::Migration[6.0]
  def change
    create_table :sjabloon_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :policy_id, null: false
      t.datetime :agreed_at

      t.timestamps
    end
  end
end

