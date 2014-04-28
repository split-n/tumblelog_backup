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
    items = [:target_account,:last_id,:next_count]
    items.all?{|it| state.has_key?(it) }
  end

  def initialize(tumblr_host,oauth_config)
    @base = Tumblelog.new(tumblr_host,oauth_config)
    @last_id = 10**18 # todo fix
    @next_count = 0
  end

  def load(state) # todo: should not public
    @last_id = state[:last_id]
    @next_count = state[:next_count]
    nil
  end

  # カウント方法の問題から、each_postは一回のみしか正常に実行できない
  def each_post
    return self.to_enum(:each_post) unless block_given?
    raise "You cannot rewind enumeration" if @called
    @called = true
    # 前回のnext_countから再開しても、
    # 投稿が増えてずれている可能性があるため
    last_id_prev = @last_id
    @base.each_post(@next_count) do |post|
      if post.id < last_id_prev
        @last_id = post.id
        @next_count += 1
        yield post # yield 直後でEnumeratorが止まるので、最後に置く必要がある
      end
    end
  end

  def save_state
    state = {
      target_account: @base.tumblr_host,
      last_id: @last_id,
      next_count: @next_count
    }
    JSON.generate(state)
  end

end

