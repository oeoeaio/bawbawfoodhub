source 'https://rubygems.org'

ruby "2.7.6"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'

# Use postgres as the database for Active Record
gem 'pg', '>= 1.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9'

gem 'puma'

gem "comfortable_mexican_sofa", git: 'https://github.com/comfy/comfortable-mexican-sofa', ref: '07fa555' # Need this version to fix imports
gem 'image_processing', '~> 1.12'
gem 'haml', '~> 5.0'
gem 'foundation-rails', '~> 5.5.3'
gem 'font-awesome-sass', '>= 4.7'
gem 'pundit', '~> 1.0'
gem 'devise', ">= 4.7.1"
gem 'roadie-rails', '~> 3.0'
gem 'roo'
gem 'httparty'
gem 'whenever', :require => false
gem 'twilio-ruby'
gem 'rollbar'
gem 'recaptcha'
gem 'nokogiri', '>= 1.11.5' # Vulnerability
gem 'json', '>= 2.5.1' # Vulnerability
gem 'loofah', '>= 2.9.1' # Vulnerability
gem 'net-http' # Fix warnings
gem 'bootsnap'

group :development, :test do
  gem 'rspec-rails', '~> 5.0'
  gem 'factory_girl_rails', '~> 4.6'
  gem 'faker', '~> 2.10'
  gem 'pry-byebug'
  gem 'listen'
end

group :test do
  gem 'shoulda-matchers', '~> 4.1'
  gem 'capybara', '~> 3.33'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
