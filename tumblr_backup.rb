#!/usr/bin/env ruby
# encoding:utf-8
require 'bundler'
require 'optparse'
require 'yaml'
require_relative 'lib/loader.rb'


options = {}
OptionParser.new do |parser|
  parser.on('-d','--development') {options[:development] = true }
  parser.on('-a','--account ACCOUNT') {|v| options[:account] = v }
  parser.on('-o','--output DEST_DIR') {|v| options[:dest_dir] = v }
  parser.on('-s','--split-json') {options[:split_json] = true }
  parser.parse!(ARGV)
end

if options[:development]
  Bundler.require(:default,:development)
else
  Bundler.require
end

unless options[:account]
  warn <<-'EOF'
  invalid arguements.

  usage: ./tumblr_backup.rb -a YOUR_ACCOUNT_OR_DOMAIN [-o OUTPUT_DIR] [-s ]
  Options in [ ] is optional.
  -s to split json saving folder.
  Files is being saved to __dir__/save/ unless -o option
  EOF
  exit(1)
end

config_file_path = File.expand_path(File.dirname(__FILE__)) + "/apikey.yml"
begin
  tmp = YAML.load_file(config_file_path)
rescue
  warn <<-'EOF'
  apikey.yml is missing . 
  please read README.md .
  EOF
  exit(1)
end
config = tmp.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v}

tl = Tumblelog.new(options[:account],config)

save_dir = options[:dest_dir] || File.expand_path(__dir__) + "/save/#{options[:account]}/"
store = SaveStore.new(save_dir,!!options[:split_json])

p options

tl.each_post do |post|
  begin
    store.save(post)
    puts "download #{post.id}"
  rescue SaveFailedError
    puts "save failed: #{post.id}"
  end
end




