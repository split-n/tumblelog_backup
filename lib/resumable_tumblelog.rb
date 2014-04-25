# encoding:utf-8
class ResumableTumblelog

  def self.restore(state_json,oauth_config)
    state = JSON.parse(state_json,symbolize_names:true)
    raise "Invalid state file" unless verify_state(state)
    me = self.allocate
    me.load(state)
    me
  end

  def self.verify_state(state)
    items = [:target_account,:last_id,:next_count]
    items.all?{|it| state.has_key?(it) }
  end

  def initialize(tumblr_host,oauth_config)
    @holder = TumblelogHolder.new(tumblr_host,oauth_config)
  end

  def load(state)
    @holder = TumblelogHolder.new(state[:target_account],
                                  state[:last_id],
                                  state[:next_count])

  end


  # カウント方法の問題から、each_postは一回のみしか正常に実行できない
  def each_post
    return self.to_enum(:each_post) unless block_given?
    raise "You cannot rewind enumeration" if @called
    @called = true
  end

  def save_state
    state = {
      target_account: @base.tumblr_host,
      last_id: @last_id,
      next_count: @next_count
    }
    JSON.generate(state)
  end

  class TumblelogHolder

    def initialize(tumblr_host,oauth_config,last_id=nil,next_count=nil)
      if !last_id || !next_count
        @base = Tumblelog.new(tumblr_host,oauth_config)
      else

      end
    end

    def each_post

    end

    def find_startable_count(tumblr_host,oauth_config,last_id,next_count)
      base = Tumblelog.new(tumblr_host,oauth_config)

      # 順に進んでいけば元の地点に辿り着ける場合
      if base.each_post(next_count).first.id >= last_id
        return 


      else

      end
    end



end

