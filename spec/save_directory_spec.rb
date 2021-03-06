# encoding:utf-8
require 'bundler'
require_relative '../lib/tumblr_lib/save_directory.rb'
require 'tmpdir'

describe SaveDirectory do

  context "normal options test" do
    before :each do
      @save_root_path = Dir.mktmpdir
    end

    after :each do
      FileUtils.remove_entry_secure @save_root_path
    end

    it "分離されていないcontentフォルダを取得できる" do
      dir = SaveDirectory.new(@save_root_path,false)
      expect_dir = @save_root_path + '/photo'
      expect(dir.for_content[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_truthy
    end

    it "分離されたcontentフォルダを取得できる" do
      dir = SaveDirectory.new(@save_root_path,true)
      expect_dir = @save_root_path + '/photo/photo'
      expect(dir.for_content[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_truthy
    end

    it "分離されていないjsonフォルダを取得できる" do
      dir = SaveDirectory.new(@save_root_path,false)
      expect_dir = @save_root_path + '/json'
      expect(dir.for_json[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_truthy
    end

    it "分離されたjsonフォルダを取得できる" do
      dir = SaveDirectory.new(@save_root_path,true)
      expect_dir = @save_root_path + '/photo/json'
      expect(dir.for_json[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_truthy
    end
  end

  context "directory path test" do
    before :each do
      @save_root_path = Dir.mktmpdir
    end

    after :each do
      FileUtils.remove_entry_secure @save_root_path
    end

    it "ディレクトリ終端に/が付いていてもよい" do
      dir = SaveDirectory.new(@save_root_path+'/',false)
      expect_dir = @save_root_path + '/photo'
      expect(dir.for_content[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_truthy
    end
  end
end
