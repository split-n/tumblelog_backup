# encoding:utf-8
class PostFactory
  TYPES = %w(text quote link answer video audio photo chat).map(&:to_sym)
  def self.create(hash)
    type = hash["type"].to_sym
    return case type
    when :text
      TextPost.new(hash)
    when :quote
      QuotePost.new(hash)
    when :link
      LinkPost.new(hash)
    when :answer
      AnswerPost.new(hash)
    when :video
      VideoPost.new(hash)
    when :audio
      AudioPost.new(hash)
    when :chat
      ChatPost.new(hash)
    when :photo
      PhotoPost.new(hash)
    else
      nil
    end

  end

end

