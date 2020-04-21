    <%= @module_name.present? ? "module #{@module_name.camelize}::#{@class_name}" : "class #{@class_name}" %>

  def initialize(params, view_context = nil)
    @params       = params
    @view_context = view_context
  end

  <%= "# class methods" if !methods.any? %>
  <% for method in methods %>
  def <%= method %>
  end
  <% end %>

  private

  attr_reader :params

  def h
    @view_context
  end
end

