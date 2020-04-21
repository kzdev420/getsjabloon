    class FormGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :methods, type: :array, default: [], banner: "attributes attributes"
  class_option :module, type: :string

  def create_form_file
    @module_name = options[:module]
    @class_name  = class_name.downcase.include?("form") ? class_name : "#{class_name}Form"

    form_dir_path      = "app/forms"
    generator_dir_path = form_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
    generator_path     = generator_dir_path + "/#{@class_name.underscore}.rb"

    Dir.mkdir(form_dir_path)      unless File.exist?(form_dir_path)
    Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)

    template "form_template.rb", generator_path
  end
end

