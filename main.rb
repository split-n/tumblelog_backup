# encoding:utf-8
require 'bundler'
require 'optparse'
require 'yaml'
require_relative 'app/downloader'


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

config = YAML.load_file("apikey.yml")


Tumblr.configure do |conf|
  conf.consumer_key = config["consumer_key"]
  conf.consumer_secret = config["consumer_secret"]
  conf.oauth_token = config["oauth_token"]
  conf.oauth_token_secret = config["oauth_token_secret"]
end

