# encoding:utf-8
class PostFactory
  # all of types : 
  # text, quote, link, answer, video, audio, photo, chat
  def self.create(hash)
    type = hash["type"].to_sym
    return case type
    when :photo
      PhotoPost.new(hash)
    else
      nil
    end

  end

end

