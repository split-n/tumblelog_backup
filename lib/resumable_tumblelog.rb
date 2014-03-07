# encoding:utf-8
class ResumableTumblelog

  def self.restore(state_json,oauth_config)
    state = JSON.parse(state_json,symbolize_names:true)
    raise "Invalid state file" unless verify_state(state)
    me = self.new(state[:target_account],oauth_config)
    me.load(state)
    me
  end

  def self.verify_state(state)
    items = [:target_account,:last_id,:last_count]
    items.all?{|it| state.has_key?(it) }
  end

  def initialize(tumblr_host,oauth_config)
    @base = Tumblelog.new(tumblr_host,oauth_config)
    @previous_state = {
      target_account: tumblr_host,
      last_id: 10**18, # todo fix
      last_count: 0
    }
  end

  def load(state) # todo: should not public
    @previous_state = state
    nil
  end

  # カウント方法の問題から、each_postは一回のみしか正常に実行できない
  def each_post
    return self.to_enum(:each_post) unless block_given?
    raise "You cannot rewind enumeration" if @called
    @called = true
    # 前回のlast_countから再開しても、
    # 投稿が増えてずれている可能性があるため
    @last_count = @previous_state[:last_count] - 1
    @base.each_post(@previous_state[:last_count]) do |post|
      if post.id < @previous_state[:last_id]
        yield post
        @last_id = post.id
        @last_count += 1
      end
    end
  end

  def save_state
    state = {
      target_account: @base.tumblr_host,
      last_id: @last_id,
      last_count: @last_count
    }
    JSON.generate(state)
  end

end

