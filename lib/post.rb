# encoding:utf-8
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

  def save(store_obj)
    # photo,videoはhrefから個別ファイルとして保存
    # その他はとりあえずjsonのままで
    case type
    when :photo

    when :video

    when :link,:text,:quote

    end

  end
end
