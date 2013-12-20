# encoding:utf-8
require 'bundler'
require 'yaml'
require 'json'
Bundler.require(:default,:development)

tmp = YAML.load_file("apikey.yml")
config = tmp.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v} 
# hash key string to symbol



client = Tumblr::Client.new(config)

binding.pry
