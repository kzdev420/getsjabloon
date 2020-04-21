require "ostruct"
require "yaml"

config     = YAML.load_file(Rails.root.join("config", "app_config.yml")) || {}
app_config = config[Rails.env] || {}
AppConfig  = OpenStruct.new(app_config)

