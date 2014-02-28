# encoding:utf-8
require 'bundler'
require_relative '../lib/loader.rb'
require 'tmpdir'
Bundler.require

describe SaveDirectory do

  context "normal options test" do
    before :each do
      @save_root_path = Dir.mktmpdir
    end

    after :each do
      FileUtils.remove_entry_secure @save_root_path
    end

    it "分離されていないcontentフォルダを取得できる" do
      dir = SaveDirectory.new(save_root_path:@save_root_path,each_folder_json:false)
      expect_dir = @save_root_path + '/photo'
      expect(dir.for_content[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_true
    end

    it "分離されたcontentフォルダを取得できる" do
      dir = SaveDirectory.new(save_root_path:@save_root_path,each_folder_json:true)
      expect_dir = @save_root_path + '/photo/photo'
      expect(dir.for_content[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_true
    end

    it "分離されていないcontentフォルダを取得できる" do
      dir = SaveDirectory.new(save_root_path:@save_root_path,each_folder_json:false)
      expect_dir = @save_root_path + '/json'
      expect(dir.for_json[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_true
    end

    it "分離されたjsonフォルダを取得できる" do
      dir = SaveDirectory.new(save_root_path:@save_root_path,each_folder_json:true)
      expect_dir = @save_root_path + '/photo/json'
      expect(dir.for_json[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_true
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
      dir = SaveDirectory.new(save_root_path:@save_root_path+'/',each_folder_json:false)
      expect_dir = @save_root_path + '/photo'
      expect(dir.for_content[:photo]).to eq expect_dir
      expect(Dir.exist? expect_dir).to be_true
    end
  end
end
