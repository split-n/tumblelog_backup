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

  def id
    @data["id"]
  end

  def save(store_obj)
    raise NotImplementedError
  end

end
