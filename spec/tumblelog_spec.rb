# encoding:utf-8
require 'yaml'
require 'bundler'
require_relative '../lib/tumblr_lib/tumblelog.rb'

describe Tumblelog do
  before :all do
    config_file_path = "#{__dir__}/apikey.yml"
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

    it "host名を取得できる" do
      expect(@tumblelog.tumblr_host).to eq "testumr.tumblr.com"
    end

    it "post数のカウントが正確" do
      expect(@tumblelog.each_post.count).to eq POSTS_COUNT
    end

    it "#post_count" do
      expect(@tumblelog.post_count).to eq POSTS_COUNT
    end

    it "画像が1個" do
      photos = @tumblelog.each_post.select{|p| p.type == :photo}
      expect(photos.count).to eq 1
    end

    it "range指定がうまくいく" do
      posts_from = 5
      ranged_posts = @tumblelog.each_post(posts_from,Float::INFINITY).to_a
      cut_posts = @tumblelog.each_post.to_a[posts_from..-1]
      expect(
        ranged_posts.zip(cut_posts).any?{|pair|
          pair[0].id != pair[1].id } 
      ).to be_false
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

    it "全部のpostのidが正確" do
      expect_ids = [71307438418,71307185951,71305811722,
       71305688040,71303584893,71302197206,
       71302135845,71302067438
      ]
      ids = @tumblelog.each_post.map(&:id)
      expect(ids).to eq expect_ids
    end
  end

  context "misc" do 
    before :all do
      @testumr = Tumblelog.new("testumr",@config)
    end

    it "のeach_postへブロックを渡した結果が渡さない結果と同様" do
      posts_id = []
      @testumr.each_post do |post|
        posts_id << post.id
      end

      expect(posts_id).to eq @testumr.each_post.to_a.map(&:id)
    end
  end

end

