class Tumblelog
  include Enumerable

  def initialize(tumblr_host,oauth_config)
    @tumblr_host = tumblr_host
    @client = Tumblr::Client.new(oauth_config)
    blog_info = @client.blog_info(@tumblr_host)
    if blog_info["status"] == 404
      raise ArgumentError.new("Invalid Hostname")
    else
      @blog_info = blog_info
    end
  end


  def each_post
    unless block_given?
      return self.to_enum(:each_post)
    end

    each_post_ranged do |post|
      yield post
    end

  end

  def each_post_ranged(from=0,to=Float::INFINITY)
    #  標準の引数の場合、eachと同等の動作をする
    unless block_given?
      return self.to_enum(:each_post_ranged,from,to)
    end

    from.step(to,20) do |offset|
      # 20件ずつ落ちてくる
      # 全件取得後は空の[]が取得されるだけ
      # ホストが無効な場合はnil
      posts_20 = @client.posts(@tumblr_host,offset: offset)["posts"]
      break if posts_20.nil? || posts_20.empty?
      posts_20.each do |postdata|
        yield Post.new(postdata)
      end
    end

  end

end
