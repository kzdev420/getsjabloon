    class PresenterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :methods, type: :array, default: [], banner: "method method"
  class_option :module, type: :string

  def create_presenter_file
    @module_name = options[:module]
    @class_name  = class_name.downcase.include?("presenter") ? class_name : "#{class_name}Presenter"

    presenter_dir_path = "app/presenters"
    generator_dir_path = presenter_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
    generator_path     = generator_dir_path + "/#{@class_name.underscore}.rb"

    Dir.mkdir(presenter_dir_path)   unless File.exist?(presenter_dir_path)
    Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)

    template "presenter_template.rb", generator_path
  end
end

