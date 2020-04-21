      class Create<%= class_name.pluralize.delete('::') %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def change
    create_table :<%= table_name || plural_name.split('/').last %> do |t|
    <%- for attribute in @model_attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>
    <%= "  t.belongs_to :author" if !@skip_author %>

      t.timestamps
    end
  end
end

