source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2'

gem 'active_link_to', '~> 1.0'
gem 'bootstrap_form', github: 'bootstrap-ruby/bootstrap_form'
gem 'bootstrap', '~> 4.0'
gem 'friendly_id', '~> 5.2.4'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'sprockets', '~> 3.7.2'
gem 'sqlite3', '~> 1.3.13'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'bullet', '~> 5.7.5'
  gem 'capybara', '~> 2.16'
  gem 'factory_bot_rails', '~> 4.8'
  gem 'faker', '~> 1.8'
  gem 'pry-byebug', '~> 3.6'
  gem 'rspec-rails', '~> 3.7'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'bootsnap', '>= 1.3.0'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'terminal-notifier', '>= 2.0.0'
  gem 'terminal-notifier-guard', '>= 1.7.0'
  gem 'web-console', '>= 3.3.0'
end
