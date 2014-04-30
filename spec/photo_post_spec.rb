# encoding:utf-8
require 'bundler'
require_relative '../lib/loader.rb'
require 'tmpdir'
Bundler.require

describe PhotoPost do
  before :all do
  end

  context "正常データ" do
    let(:data)  {
      json_file = File.read("#{__dir__}/file/photo_post.json")
      JSON.load(json_file)
    }

    it "インスタンスが生成される" do
      expect {
        photo_post = PhotoPost.new(data)
      }.not_to raise_error
    end

    let(:photo_post) {
      PhotoPost.new(data)
    }

    it "idが正しい" do
      expect(photo_post.id).to eq data["id"]
    end

    it "#imageが最大の画像ファイルを返す" do
      got_image_file = photo_post.photo
      expected_image = File.binread("#{__dir__}/file/lenna.png")
      expect(got_image_file.read).to eq expected_image
    end

    it "#jsonが同じデータを返す" do
      json = photo_post.json
      expect(JSON.load(json)).to eq data
    end

    it "古くてoriginal_sizeのurlに拡張子がついてないpostでも問題ない" do
      # 下記のようなコードで実際に問題となるpostを取得できる
      # tl.each_post.lazy.select{|p|p.type == :photo}.map{|p| [p,p.send(:image_urls)]}.reject{|p| p[1][0] =~ /\.\w{3}$/}.first
      json = File.read("#{__dir__}/file/no_highres_extension.json")
      post = PhotoPost.new(JSON.load(json))
      expect(post.extension).to eq ".jpg"
    end

  end
  context "異常系" do
    it "適当な内容だとインスタンスが生成されない" do
      invalid_data = {}
      expect {
        PhotoPost.new(invalid_data)
      }.to raise_error
    end

    it "最大の画像が404のときに、小さい画像を正しく取得できる" do

      json_file = File.read("#{__dir__}/file/photo_post_max_404.json")
      post = PhotoPost.new(JSON.parse(json_file))

      got_image_file = post.photo
      expected_image = File.binread("#{__dir__}/file/photo_post_250.jpg")
      expect(got_image_file.read).to eq expected_image
    end
  end




end
