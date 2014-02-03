# encoding:utf-8
require 'bundler'
require_relative '../lib/loader.rb'
require 'tmpdir'
Bundler.require

describe SaveStore do
  context "PhotoPostを保存できる" do
    before :all do
      @json = File.read('./file/photo_post.json')
      @data = JSON.load(@json)
      @photo_post = PhotoPost.new(@data)
      @tmpdir = Dir.mktmpdir
      store = SaveStore.new(@tmpdir)
      store.save(@photo_post)
    end

    it "画像を保存できている" do
      test_photo_path = "#{@tmpdir}/photo/#{@photo_post.id}#{@photo_post.extension}"
      test_photo = File.binread(test_photo_path)
      prepared_photo = File.binread('./file/photo_post.jpg')
      expect(test_photo.size).to eq prepared_photo.size
    end

    it "jsonを保存できている" do
      test_json_path =  "#{@tmpdir}/json/#{@photo_post.id}.json"
      stored_json_file = File.read(test_json_path)
      the_data = JSON.load(stored_json_file)
      expect(the_data).to eq @data
    end


    after :all do
      FileUtils.remove_entry_secure @tmpdir
    end
  end

end



