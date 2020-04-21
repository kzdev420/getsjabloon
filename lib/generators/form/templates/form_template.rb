    <%= @module_name.present? ? "module #{@module_name.camelize}::#{@class_name}" : "class #{@class_name}" %>
  include ActiveModel::Model
  include ActiveModel::Attributes

  <% for method in methods %>
  attribute :<%= method %>, :string
  <% end %>

  def save
    if valid?
      ActiveRecord::Base.transaction do
        # call private class method
      end
    end
  end

  private
  # private class methods here
end

