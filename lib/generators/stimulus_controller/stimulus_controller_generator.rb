    class StimulusControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :functions, type: :array, default: [], banner: "functions"
  class_option :module, type: :string

  def create_presenter_file
    @module_name = options[:module]
    @class_name  = class_name.downcase.include?("controller") ? class_name : "#{class_name}_controller"

    controller_dir_path = "frontend/controllers"
    generator_dir_path  = controller_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
    generator_path      = generator_dir_path + "/#{@class_name.underscore}.js"

    Dir.mkdir(controller_dir_path) unless File.exist?(controller_dir_path)
    Dir.mkdir(generator_dir_path)  unless File.exist?(generator_dir_path)

    template "stimulus_controller_template.rb", generator_path
  end
end

