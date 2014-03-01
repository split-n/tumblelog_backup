# encoding:utf-8
class Tumblelog
  attr_reader :tumblr_host

  def initialize(tumblr_host,oauth_config)
    # ユーザー名のみを指定された場合でも、tumblrのFQDNに正規化する
    @tumblr_host = tumblr_host.include?(".") ? tumblr_host : "#{tumblr_host}.tumblr.com"
    @client = Tumblr::Client.new(oauth_config)
    blog_info = @client.blog_info(@tumblr_host)
    if blog_info["status"] == 404
      raise ArgumentError.new("Invalid Hostname")
    else
      @blog_info = blog_info["blog"]
    end
  end

  def post_count
    @blog_info["posts"]
  end


  def each_post(from=0,to=Float::INFINITY)
    #  標準の引数の場合、eachと同等の動作をする
    unless block_given?
      return self.to_enum(:each_post,from,to)
    end

    from.step(to,20) do |offset|
      # 20件ずつ落ちてくる
      # 全件取得後は空の[]が取得されるだけ
      # ホストが無効な場合はnil
      posts_20 = @client.posts(@tumblr_host,offset: offset)["posts"]
      break if posts_20.nil? || posts_20.empty?
      posts_20.each do |postdata|
        post = PostFactory.create(postdata)
        yield post if post
      end
    end
  end

end
