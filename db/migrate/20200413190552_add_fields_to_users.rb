class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :processor, :string
    add_column :users, :processor_id, :string
    add_column :users, :trial_ends_at, :datetime
    add_column :users, :card_type, :string
    add_column :users, :card_last4, :string
    add_column :users, :card_exp_month, :string
    add_column :users, :card_exp_year, :string
  end
end

