      class Tag < ActiveRecord::Base
<%= "  extend FriendlyId" if @friendly_id_available %>
<%= "  friendly_id :name, use: :slugged
" if @friendly_id_available %>
  has_many :taggings
  has_many :<%= class_name.downcase.pluralize.delete('::') %>, through: :taggings, source: :taggable, source_type: '<%= class_name.delete('::') %>'
end

