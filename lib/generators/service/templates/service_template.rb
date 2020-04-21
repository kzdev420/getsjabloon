    <%= @module_name.present? ? "module #{@module_name.camelize}::#{@class_name}" : "class #{@class_name}" %>
  def initialize(param)
    @param = param
  end

  def call
  end

  private

  attr_reader :param

<% for method in methods %>
  def <%= method %>
  end
<% end %>
end

