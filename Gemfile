source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', "6.0.2.2"
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'webpacker', '~> 4.0'

gem 'sidekiq', '~> 6.0', '>= 6.0.3'
gem 'premailer-rails', '~> 1.10', '>= 1.10.3'

gem 'devise', '~> 4.7', '>= 4.7.1'
gem 'devise_masquerade', '~> 1.2'
gem 'friendly_id', '~> 5.3'
gem 'name_of_person', '~> 1.1', '>= 1.1.1'

gem 'storext', '~> 3.1'
gem 'redis', '~> 4.1', '>= 4.1.3'
gem 'image_processing', '~> 1.12'


gem 'stripe', '~> 5.10'
gem 'stripe_event', '~> 2.3'
gem 'receipts', '~> 0.2.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'letter_opener', '~> 1.7'
  gem 'ngrok-tunnel'
  # Cool stuff for later but not really needed
  gem 'tty-box'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
