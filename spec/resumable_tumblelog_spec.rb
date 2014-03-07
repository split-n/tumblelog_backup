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
    def resume_each_times(cases)
      # [3,4] => get 3posts and get 4posts
      resm = []
      state = nil
      cases.each do |i|
        if state
          resumable = ResumableTumblelog.restore(state,@config)
        else
          resumable = ResumableTumblelog.new("staff",@config)
        end
        resm.concat resumable.each_post.lazy.map(&:id).take(i).to_a
        state = resumable.save_state
      end
      resm
    end

    before :all do
      @original = Tumblelog.new("staff",@config)
    end

    it "get 21 no resume" do
      resumable = ResumableTumblelog.new("staff",@config)

      orig = @original.each_post.lazy.map(&:id).take(21).to_a
      resm = resume_each_times([21])
      expect(resm).to eq orig
    end

    it "get3, get3" do
      times = [3,3]
      orig = @original.each_post.lazy.map(&:id).take(times.inject(&:+)).to_a
      resm = resume_each_times(times)
      expect(resm).to eq orig
    end

    it "get2, get16, get 10" do
      times = [2,16,10]
      orig = @original.each_post.lazy.map(&:id).take(times.inject(&:+)).to_a
      resm = resume_each_times(times)
      expect(resm).to eq orig
    end
  end
end


