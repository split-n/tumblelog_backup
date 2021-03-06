# encoding:utf-8
require 'yaml'
require 'bundler'
require_relative '../lib/tumblr_lib/resumable_tumblelog.rb'

describe ResumableTumblelog do
  before :all do
    config_file_path = "#{__dir__}/apikey.yml"
    tmp = YAML.load_file(config_file_path)
    @config = tmp.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v} 
  end

  context "ResumeしないTumblelogとの突き合わせ" do
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

    it "get31, get16, get 5" do
      times = [31,16,5]
      orig = @original.each_post.lazy.map(&:id).take(times.inject(&:+)).to_a
      resm = resume_each_times(times)
      expect(resm).to eq orig
    end
  end

  context "stateファイルのテスト" do
    let(:expect_ids) { [71307438418,71307185951,71305811722,71305688040,71303584893,71302197206,71302135845,71302067438 ] }

    it "default" do
      state = {
        target_account:"testumr.tumblr.com",
        last_id: 10**16,
        next_count: 0
      }
      resumable = ResumableTumblelog.restore(state,@config)

      ids = resumable.each_post.map(&:id).to_a
      expect(ids).to eq expect_ids
    end

    it "countが増えない状態でrestore" do
      state = {
        target_account:"testumr.tumblr.com",
        last_id: expect_ids[3],
        next_count: 3
      }
      resumable = ResumableTumblelog.restore(state,@config)

      ids = resumable.each_post.map(&:id).to_a
      expect(ids).to eq expect_ids[4..-1]
    end

    it "countが以前より進んでいるケース" do
      state = {
        target_account:"testumr.tumblr.com",
        last_id: expect_ids[3],
        next_count: 2 # 現在の[3]を1個目のときに取得したという想定、2つ追加されている
      }
      resumable = ResumableTumblelog.restore(state,@config)

      ids = resumable.each_post.map(&:id).to_a
      expect(ids).to eq expect_ids[4..-1]
    end

    it "すでに最後まで到達している" do
      state = {
        target_account:"testumr.tumblr.com",
        last_id: expect_ids[7],
        next_count: 0
      }
      resumable = ResumableTumblelog.restore(state,@config)

      ids = resumable.each_post.map(&:id).to_a
      expect(ids).to eq []
    end

    it "countが以前より少ないケース(前にあった投稿が削除された)" do
      state = {
        target_account:"testumr.tumblr.com",
        last_id: expect_ids[2],
        next_count: 5 #[4]で取得
      }
      resumable = ResumableTumblelog.restore(state,@config)

      ids = resumable.each_post.map(&:id).to_a
      expect(ids).to eq expect_ids[3..-1]
    end
  end
end


