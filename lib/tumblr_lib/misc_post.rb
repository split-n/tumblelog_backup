# encoding:utf-8
require_relative './post.rb'


class TextPost < Post
  def title
    @data["title"]
  end

  def body
    @data["body"]
  end
end

class QuotePost < Post
end

class LinkPost < Post
end

class AnswerPost < Post
end

class VideoPost < Post
end

class AudioPost < Post
end

class ChatPost < Post
end



