    class ContentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :arguments_for_model, type: :array, default: [], banner: "model:attributes"

  class_option :skip_author, desc: "Do not add/show author", type: :boolean
  class_option :skip_tags, desc: "Do not include tags/categories", type: :boolean
  class_option :skip_markdown, desc: "Do add the kramdown gem and initializer/helper method", type: :boolean
  class_option :skip_admin, desc: "Do not add admin controller actions and views", type: :boolean

  def initialize(*args, &block)
    super

    @model_attributes           = []
    @skip_tags                  = options.skip_tags?
    @skip_author                = options.skip_author? || !authentication_model_present?
    @skip_admin                 = options.skip_admin?
    @skip_markdown              = options.skip_markdown?
    @authentication_model_class = authentication_model_class
    @friendly_id_available      = friendly_id_is_available?

    arguments_for_model.each do |argument|
      @model_attributes << Rails::Generators::GeneratedAttribute.new(*argument.split(":"))
    end

    @model_attributes.uniq!

    if @model_attributes.empty?
      @model_attributes << Rails::Generators::GeneratedAttribute.new("title", "string")
      @model_attributes << Rails::Generators::GeneratedAttribute.new("body", "text")
      @model_attributes << Rails::Generators::GeneratedAttribute.new("slug", "string") if friendly_id_is_available?
    end
  end

  def create_resource_model
    template "resource_model.rb", "app/models/#{model_path}.rb"
  end

  def create_resource_migration
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    template "resource_migration.rb", "db/migrate/#{timestamp}_create_#{model_path.pluralize.gsub("/", "_")}.rb"
  end

  def create_tags_model
    return if @skip_tags

    if tags_already_exists?
      insert_into_file "app/models/tag.rb",
        "  has_many :#{class_name.downcase.pluralize.delete('::')}, through: :taggings, source: :taggable, source_type: '#{class_name.delete('::')}'
",
        after: "  has_many :taggings
"
    else
      template "tag_model.rb", "app/models/tag.rb"
    end
  end

  def create_tags_migration
    return if @skip_tags || tags_already_exists?

    timestamp = (Time.now + 5).strftime("%Y%m%d%H%M%S")

    template "tag_migration.rb", "db/migrate/#{timestamp}_create_tags.rb"
  end

  def create_taggable_model
    return if @skip_tags || tags_already_exists?

    template "tagging_model.rb", "app/models/tagging.rb"
  end

  def create_taggings_migration
    return if @skip_tags || tags_already_exists?

    timestamp = (Time.now + 10).strftime("%Y%m%d%H%M%S")

    template "tagging_migration.rb", "db/migrate/#{timestamp}_create_taggings.rb"
  end

  def copy_tags_partial
    return if @skip_tags || tags_already_exists?

    template "views/tags_partial.html.erb", "app/views/#{plural_name}/_tags.html.erb"
  end

  def create_tags_concern
    return if @skip_tags || tags_already_exists?

    template "taggable_concern.rb", "app/models/concerns/taggable.rb"
  end

  def create_resource_controller
    template "resource_controller.rb", "app/controllers/#{plural_name}_controller.rb"
  end

  def create_tags_controller
    return if @skip_tags || tags_already_exists?

    template "tags_controller.rb", "app/controllers/tags_controller.rb"
  end

  def create_routes
    namespaces = plural_name.split('/')
    resource   = namespaces.pop

    if @skip_tags
      route "resources :#{resource}, only: #{resource_actions}"
    else
      route "resources :#{resource}, only: #{resource_actions} do
  get 'tag/:id', on: :collection, as: 'tag', to: 'tags#show'
end

"
    end
  end

  def create_views
    view_files.each do |action|
      template "views/#{action}.html.erb", "app/views/#{plural_name}/#{action}.html.erb"
    end

    template "views/resource_partial.html.erb", "app/views/#{plural_name}/_#{singular_name}.html.erb"

    template "views/tag_show.html.erb", "app/views/tags/show.html.erb" if !@skip_tags
  end

  def initialize_gem
    return if @skip_markdown

    gem "kramdown", "~> 2.1"
  end

  private

  def singular_name
    file_name.underscore
  end

  def plural_name
    file_name.underscore.pluralize
  end

  def plural_class_name
    plural_name.camelize
  end

  def resource_actions
    if !@skip_admin
      [:index, :show, :new, :create, :edit, :update, :destroy]
    else
      [:index, :show]
    end
  end

  def view_files
    files = %w[index show]
    files.push("new", "edit", "_form") if !@skip_admin

    files
  end

  def instance_name
    if @namespace_model
      singular_name.gsub('/','_')
    else
      singular_name.split('/').last
    end
  end

  def instances_name
    instance_name.pluralize
  end

  def table_name
    plural_name
  end

  def class_name
    file_name.camelize
  end

  def model_path
    class_name.underscore
  end

  private

  def tags_already_exists?
    File.exists?(Rails.root.join("app/models/tag.rb")) &&
      File.exists?(Rails.root.join("app/models/tagging.rb")) &&
        File.exists?(Rails.root.join("app/models/concerns/taggable.rb")) &&
        File.exists?(Rails.root.join("app/controllers/tags_controller.rb"))
  end

  def friendly_id_is_available?
    File.exists?(Rails.root.join("config/initializers/friendly_id.rb"))
  end

  def authentication_model_present?
    File.exists?(Rails.root.join("app/models/user.rb")) ||
      File.exists?(Rails.root.join("app/models/account.rb")) ||
        File.exists?(Rails.root.join("app/models/person.rb"))
  end

  def authentication_model_class
    return if !authentication_model_present?

    if File.exists?(Rails.root.join("app/models/user.rb"))
      "User"
    elsif File.exists?(Rails.root.join("app/models/account.rb"))
      "Account"
    elsif File.exists?(Rails.root.join("app/models/person.rb"))
      "Person"
    end
  end
end

