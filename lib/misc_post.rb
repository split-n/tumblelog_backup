# encoding:utf-8

# とりあえずjsonだけ保存しておくことにする

module JsonSaver
  def save(store_obj)
    store_obj.save_json(@data,id)
  end
end



class TextPost < Post
  include JsonSaver
end

class QuotePost < Post
  include JsonSaver
end

class LinkPost < Post
  include JsonSaver
end

class AnswerPost < Post
  include JsonSaver
end

class VideoPost < Post
  include JsonSaver
end

class AudioPost < Post
  include JsonSaver
end

class ChatPost < Post
  include JsonSaver
end



