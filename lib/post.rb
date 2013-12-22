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
    post_id = @data["id"]
    case type
    when :photo
      store_obj.save_photo(detect_larger_image_urls,post_id)


    when :video

    when :link,:text,:quote

    end

  end

  private
  def detect_larger_image_urls
    # 良質なものから順に配列で複数urlを返す
    # urlがあっても取得できない場合があるので
    source = @data["source_url"]
    photos = @data["photos"][0]
    original_size = photos["original_size"]
    alt_sizes = photos["alt_sizes"]
    alt_maxes = alt_sizes.sort_by{|img| -(img["width"] * img["height"]) }.take(2)

    images = []
    images << source if source
    images << original_size["url"] if original_size
    images.concat(alt_maxes.map{|p| p["url"] } ) 

    images
  end
end
