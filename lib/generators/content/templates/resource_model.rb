      class <%= class_name %> < ActiveRecord::Base
<%= "  extend FriendlyId" if @friendly_id_available %>
<%= "  friendly_id :title, use: :slugged" if @friendly_id_available %>
<%= "  include Taggable" if !@skip_tags %>
<%= "  belongs_to :author, class_name: '#{authentication_model_class}' 
" if !@skip_author %>

  validates :title, :body, presence: true
end

