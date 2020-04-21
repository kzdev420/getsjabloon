      class <%= plural_class_name %>Controller < ApplicationController
  before_action :set_<%= instance_name %>, only: [:show<%= ", :edit, :update, :destroy" if !@skip_admin %>]
<%= "  before_action :redirect_to_route_not_found, unless: :user_is_admin?, only: [:new, :create, :edit, :update, :destroy]" if !@skip_admin %>

  def index
    @<%= instances_name %> = <%= class_name %>.order(created_at: :desc)
  end

  def show
  end
<% if !@skip_admin %>
  def new
    @<%= instance_name %> = <%= class_name %>.new
  end

  def create
    @<%= instance_name %> = <%= class_name %>.new(<%= instance_name %>_params)
    <%= "@#{instance_name}.author = current_user" if !@skip_author %>

    if @<%= instance_name %>.save!
      redirect_to <%= instance_name %>_path(@<%= instance_name %>), notice: 'Created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @<%= instance_name %>.update!(<%= instance_name %>_params)
      redirect_to <%= instance_name %>_path(@<%= instance_name %>), notice: 'Updated'
    else
      render :edit
    end
  end

  def destroy
    @<%= instance_name %>.destroy!

    redirect_to <%= plural_name %>_path, notice: 'Removed'
  end
<% end %>

  private
<% if !@skip_admin %>
  def redirect_to_route_not_found
    raise ActionController::RoutingError, "Not Found"
  end

  def user_is_admin?
    current_user&.admin?
  end

  def <%= instance_name %>_params
    params.require(:<%= instance_name %>).permit(
    <%- for attribute in @model_attributes -%>
      :<%= attribute.name %>,
    <%- end -%>
    <%= "  tag_ids: []" if !@skip_tags %>
    )
  end
<% end %>

  def set_<%= instance_name %>
    <%= "@#{instance_name} = #{class_name}.friendly.find(params[:id])" if @friendly_id_available %>
    <%= "@#{instance_name} = #{class_name}.find(params[:id])" if !@friendly_id_available %>
  end
end

