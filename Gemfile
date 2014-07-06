# A sample Gemfile
source "https://rubygems.org"
target_ruby_version = '2.0.0'
if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new(target_ruby_version)
  puts "Use ruby #{target_ruby_version}+ (Your version is #{RUBY_VERSION})"
  exit(1)
end

group :default do
  gem 'tumblr_client', "~>0.8.3"
  gem 'json', "~>1.8.1"
end

group :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rescue'
end

group :test do
  gem 'rspec'
end
