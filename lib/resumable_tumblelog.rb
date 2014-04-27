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
  end

  def load(state)
    @last_id = state[:last_id]
    @next_count = state[:next_count]
  end


  # カウント方法の問題から、each_postは一回のみしか正常に実行できない
  def each_post
    return self.to_enum(:each_post) unless block_given?
    raise "You cannot rewind enumeration" if @called
    @called = true

    last_id = @last_id
    next_count = @next_count

    @last_id ||= 10**14

    enumerate_above_last(last_id,next_count) do |post|
      if post[0].id < @last_id       
        @last_id = post[0].id
        @next_count = post[1]
        yield post[0]
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

  private
  # このメソッドは、最低でもlast_id以上の
  # idのpostから始まるEnumeratorを返す責務がある
  # enumerate: [post,count]
  def enumerate_above_last(last_id,next_count)
    origin_last_id = last_id
    if !last_id || !next_count # state情報がない場合は普通に
      next_count = 0
      @base.each_post do |post|
        next_count += 1
        yield [post,next_count]
      end
    else # 旅に出る
      found = false
      until found
        @base.each_post(next_count) do |post|
          if post.id > origin_last_id # ready for enumerate
            found = true;
            next_count += 1
            yield [post,next_count]
          else
            if found # すでに見つかっていて、last_idより下のpostが出てきたとき
              next_count += 1
              yield [post,next_count]
            else
              next_count -= 20
              if next_count < 0 # if over
                found = true
                next_count = 0
              end
              break
            end
          end
        end
      end

    end
  end

end

=begin
とりあえずbaseにnext_countで取らせる
・last_idより大きいpostが帰ってきた場合
→問題ない
・last_idより小さいpostが帰ってきた場合
→-20ずつカウントをデクリメントしていき、last_idより大きいpostまで戻る

ここから共通:
last_idより小さいpostまで進めてyieldを開始する

重要点：無駄に取得回数を増やさない
=end






