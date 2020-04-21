      class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      <%= "t.string :slug, null: false" if @friendly_id_available %>

      t.timestamps null: false
    end
  end
end


