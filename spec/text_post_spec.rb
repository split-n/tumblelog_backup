# encoding:utf-8
require 'bundler'
require_relative '../lib/tumblr_lib/misc_post.rb'
require 'tmpdir'
require 'json'

describe TextPost do
  before :all do
  end

  context "正常データ" do
    let(:data)  {
      json_file = File.read("#{__dir__}/file/text_post.json")
      JSON.load(json_file)
    }

    it "インスタンスが生成される" do
      expect {
        text_post = TextPost.new(data)
      }.not_to raise_error
    end

    let(:text_post) {
      TextPost.new(data)
    }

    it "idが正しい" do
      expect(text_post.id).to eq data["id"]
    end

    it "#bodyが本文を返す" do
      expected_body = data["body"]
      expect(text_post.body).to eq expected_body
    end

    it "#titleがタイトルを返す" do
      expected_title = data["title"]
      expect(text_post.title).to eq expected_title
    end

    it "#jsonが同じデータを返す" do
      json = text_post.json
      expect(JSON.load(json)).to eq data
    end

  end
  context "異常系" do
    it "適当な内容だとインスタンスが生成されない" do
      invalid_data = {}
      expect {
        TextPost.new(invalid_data)
      }.to raise_error
    end

  end




end
