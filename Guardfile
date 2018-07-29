guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w(erb))
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  # Controllers, views and routes are covered by feature and request specs
  [rails.controllers, rails.views, rails.routes].each do |path|
    watch(path) { ["#{rspec.spec_dir}/requests", "#{rspec.spec_dir}/features"] }
  end

  # Rails config changes
  watch(rails.spec_helper) { rspec.spec_dir }
end
