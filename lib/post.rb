# encoding:utf-8
class Post
  def initialize(post_data)
    @data = post_data
    raise unless @data["id"]
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

  def json
    JSON.generate(@data)
  end

end
