# encoding:utf-8
require 'yaml'
require 'bundler'
require_relative '../lib/loader.rb'
Bundler.require

describe ResumableTumblelog do
  before :all do
    config_file_path = "#{__dir__}/apikey.yml"
    tmp = YAML.load_file(config_file_path)
    @config = tmp.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v} 
  end

  context "a" do
    before :all do
      @original = Tumblelog.new("staff",@config)
    end

    it "get 21 no resume" do
      resumable = ResumableTumblelog.new("staff",@config)

      orig = @original.each_post.lazy.map(&:id).take(21).to_a
      resm = resumable.each_post.lazy.map(&:id).take(21).to_a
      expect(resm).to eq orig
    end

    it "get3, resume, get3" do
      resumable = ResumableTumblelog.new("staff",@config)
      orig = @original.each_post.lazy.map(&:id).take(6).to_a

      resm = []
      resm.concat resumable.each_post.lazy.map(&:id).take(3).to_a
      state = resumable.save_state
      resumable_2 = ResumableTumblelog.restore(state,@config)
      resm.concat resumable_2.each_post.lazy.map(&:id).take(3).to_a

      expect(resm).to eq orig
    end
  end
end


