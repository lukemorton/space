source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'

gem 'active_link_to', '~> 1.0'
gem 'babel-transpiler', '~> 0.7.0'
gem 'bootstrap_form', github: 'bootstrap-ruby/bootstrap_form'
gem 'bootstrap', '~> 4.0'
gem 'devise', '~> 4.4.3'
gem 'double_entry', '~> 1.0.1'
gem 'friendly_id', '~> 5.2.4'
gem 'jquery-rails', '~> 4.3.3'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'sentry-raven', '~> 2.7.4'
gem 'sprockets', '4.0.0.beta8'
gem 'sqlite3', '~> 1.3.13'
gem 'turbolinks', '~> 5'
gem 'uglifier', '~> 4.1.19'

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
  gem 'guard-rspec', '>= 4.7.3'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'terminal-notifier', '>= 2.0.0'
  gem 'terminal-notifier-guard', '>= 1.7.0'
  gem 'web-console', '>= 3.3.0'
end
