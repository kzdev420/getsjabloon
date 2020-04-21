    class QueryGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :methods, type: :array, default: [], banner: "method method"
  class_option :module, type: :string

  def create_query_file
    @module_name = options[:module]
    @class_name  = class_name.downcase.include?("query") ? class_name : "#{class_name}Query"

    query_dir_path     = "app/queries"
    generator_dir_path = query_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
    generator_path     = generator_dir_path + "/#{@class_name.underscore}.rb"

    Dir.mkdir(query_dir_path)   unless File.exist?(query_dir_path)
    Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)

    template "query_template.rb", generator_path
  end
end

