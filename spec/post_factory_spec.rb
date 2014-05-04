# encoding:utf-8
require 'bundler'
require_relative '../lib/tumblr_lib/post_factory.rb'
Bundler.require

describe PostFactory do
  it "PhotoならPhotoPostのインスタンスを生成する" do
    json = File.read("#{__dir__}/file/photo_post.json")
    hash = JSON.load(json)

    instance = PostFactory.create(hash)

    expect(instance).to be_instance_of PhotoPost
  end

end

