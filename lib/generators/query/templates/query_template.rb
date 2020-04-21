    <%= @module_name.present? ? "module #{@module_name.camelize}::#{@class_name}" : "class #{@class_name}" %>

  def initialize(relation)
    @relation = relation
  end

  def resolve
    # your query here
    relation
  end

  private

  attr_reader :relation
<% for method in methods %>
  def <%= method %>
  end
<% end %>
end

