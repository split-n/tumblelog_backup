# encoding:utf-8
class PostFactory
  # all of types : 
  # text, quote, link, answer, video, audio, photo, chat
  def self.create(hash)
    type = hash["type"].to_sym
    case type
    when :photo
      return PhotoPost.new(hash)
    when :quote
      return QuotePost.new(hash)
    else
      return OtherPost.new(hash)
    end


  end

end

