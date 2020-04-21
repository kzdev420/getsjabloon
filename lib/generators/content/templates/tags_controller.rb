      class TagsController < ApplicationController
  before_action :set_resource, only: [:show]

  def show
    <%= "@tag       = Tag.friendly.find(params[:id])" if @friendly_id_available %>
    <%= "@tag       = Tag.find(params[:id])" if !@friendly_id_available %>
    @resources = resource_class.
      joins(:tags).
      where(tags: { slug: params[:id] }).
      order(created_at: :desc)
  end

  private

  def set_resource
    @resource_plural   = resource
    @resource_singular = resource.singularize
  end

  def resource
    request.path.split("/").second
  end

  def resource_class
    resource.singularize.classify.constantize
  end
end

