# encoding:utf-8
require 'bundler'
require_relative '../lib/loader.rb'
require 'tmpdir'
Bundler.require

describe SaveStore do
  it "画像が保存できるのを確認" do
    Dir.mktmpdir do |tmpdir|
      img_url = 'http://upload.wikimedia.org/wikipedia/commons/thumb/3/36/13-09-01-kochtreffen-wien-RalfR-02.jpg/800px-13-09-01-kochtreffen-wien-RalfR-02.jpg'
      target = [img_url]
      store = SaveStore.new(tmpdir)
      store.save_photo(target,"test")

      expect_path = "#{tmpdir}photo/test.jpg"
      expect(File.exist?(expect_path)).to be_true
    end
  end

  it "2kb以下の画像でも保存できる" do
    Dir.mktmpdir do |tmpdir|
      img_url = 'http://k.yimg.jp/images/top/sp2/cmn/logo-ns-130528.png'
      target = [img_url]
      store = SaveStore.new(tmpdir)
      store.save_photo(target,"test")

      expect_path = "#{tmpdir}photo/test.png"
      expect(File.exist?(expect_path)).to be_true
    end
  end

  it "保存できない時は例外" do
    Dir.mktmpdir do |tmpdir|
      img_url = 'http://www.example.com/abc.jpg'
      target = [img_url]
      store = SaveStore.new(tmpdir)
      expect{
      store.save_photo(target,"test")
      }.to raise_error SaveFailedError
    end
  end

  it "hashをjsonで保存できる、内容が一致する" do
    Dir.mktmpdir do |tmpdir|
      target = {"abc" => 123,"def" => "456"}
      store = SaveStore.new(tmpdir)
      store.save_json(target,"test")

      expect_path = "#{tmpdir}json/test.json"
      expect(File.exist?(expect_path)).to be_true

      result = JSON.load(File.read(expect_path))
      expect(target).to eq result
    end
  end

end

