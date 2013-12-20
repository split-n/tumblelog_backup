# encoding:utf-8
require 'json'

class TbDownloader
  def initialize(tumblr_host,oauth_config)
    @posts = Posts.new(tumblr_host,oauth_config)
    @store = SaveStore.new
  end

  def download_all
    
  end

  def download_times(times)
    # times 個dlして終了

  end
end

class Post
  def initialize(post_data)
    @data = post_data
  end

  def type
    @data["type"].to_sym
  end

  def date
    DateTime.parse(@data["date"])
  end

  def save
    # photo,videoはhrefから個別ファイルとして保存
    # その他はとりあえずjsonのままで
    case type
    when :photo

    when :video

    when :link,:text,:quote

    end

  end
end


class Posts
  include Enumerable

  def initialize(tumblr_host,oauth_config)
    @client = Tumblr::Client.new(config)
  end

  def each
    # 20件ずつ落ちてくる
    # 全件取得後は空の[]が取得されるだけ
    unless block_given?
      return self.to_enum
    end

    offset = 0
    loop do
      posts_20 = @client.posts(tumblr_host,offset: offset)["posts"]
      break if posts_20.empty?
      posts_20.each do |postdata|
        yield Post.new(postdata)
      end
      offset += 20
    end
  end

end


class SaveStore
  def initialize(save_dir_name)

  end

  def save_quote(json)

  end

  def save_image(json)

  end

end
