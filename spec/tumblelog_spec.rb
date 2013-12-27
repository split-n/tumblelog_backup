# encoding:utf-8
require 'yaml'
require 'bundler'
require_relative '../lib/loader.rb'
Bundler.require

describe Tumblelog do
  before :all do
    config_file_path = File.expand_path(File.dirname(__FILE__)) + "/apikey.yml"
    tmp = YAML.load_file(config_file_path)
    @config = tmp.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v} 
  end
  
  context "インスタンス生成について" do
    it "無効なユーザーのときは例外を投げる" do
      expect {Tumblelog.new("google.com",@config)}.to raise_error
    end

    it "有効なユーザーのときインスタンスが生成できる" do
      expect {Tumblelog.new("staff",@config)}.not_to raise_error
      expect {Tumblelog.new("staff.tumblr.com",@config)}.not_to raise_error
    end
  end

  context "テスト用Tumblelogとの突き合わせ" do
    POSTS_COUNT = 8
    before :all do
      @tumblelog = Tumblelog.new("testumr",@config)
    end

    it "post数のカウントが正確" do
      expect(@tumblelog.each_post.count).to eq POSTS_COUNT
    end

    it "画像が1個" do
      photos = @tumblelog.each_post.select{|p| p.type == :photo}
      expect(photos.count).to eq 1
    end

    it "range指定がうまくいく" do
      posts = @tumblelog.each_post_ranged(5,Float::INFINITY).to_a
      expect(posts.count).to eq POSTS_COUNT - 5
    end

    it "全部のpostのクラスが正確" do
      posts = @tumblelog.each_post.to_a
      posts.sort_by!{|post| post.date } # older to newer
      expect(posts[0]).to be_instance_of TextPost
      expect(posts[1]).to be_instance_of PhotoPost
      expect(posts[2]).to be_instance_of QuotePost
      expect(posts[3]).to be_instance_of LinkPost
      expect(posts[4]).to be_instance_of ChatPost
      expect(posts[5]).to be_instance_of AudioPost
      expect(posts[6]).to be_instance_of VideoPost
      expect(posts[7]).to be_instance_of AnswerPost
    end
  end
end
