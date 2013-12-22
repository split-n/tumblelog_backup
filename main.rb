# encoding:utf-8
require 'bundler'
require 'optparse'
require 'yaml'
require_relative 'lib/post'
require_relative 'lib/save_store'
require_relative 'lib/tumblelog'


options = {}
OptionParser.new do |parser|
  parser.on('-d','--development') {options[:development] = true }
  parser.on('-a','--account ACCOUNT') {|v| options[:account] = v }
  parser.parse!(ARGV)
end

unless options[:account]
  $stderr.puts "invalid arguements"
  exit(1)
end
Account = options[:account]

if options[:development]
  Bundler.require(:default,:development)
else
  Bundler.require
end

config_file_path = File.expand_path(File.dirname(__FILE__)) + "/apikey.yml"
tmp = YAML.load_file(config_file_path)
config = tmp.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v} 



