# encoding:utf-8
require 'bundler'
require_relative '../lib/loader.rb'
require 'tmpdir'
Bundler.require

describe PhotoPost do
  before :all do
  end

  let(:data)  {
    json_file = File.read('./file/photo_post.json')
    JSON.load(json_file)
  }


  it "インスタンスが生成される" do
    expect {
      photo_post = PhotoPost.new(data) 
    }.not_to raise_error
  end

  it "適当な内容だとインスタンスが生成されない" do
    invalid_data = {}
    expect {
      PhotoPost.new(invalid_data) 
    }.to raise_error
  end

  context "インスタンス生成後" do

    let(:photo_post) {
      PhotoPost.new(data)
    }

    it "idが正しい" do
      expect(photo_post.id).to eq data["id"]
    end

    it "#imageが最大の画像ファイルを返す" do
      got_image_file = photo_post.photo
      expected_image = File.binread('./file/lenna.png')
      expect(got_image_file.read).to eq expected_image
    end

    it "#jsonが同じデータを返す" do
      json = photo_post.json
      expect(JSON.load(json)).to eq data
    end

  end

end
