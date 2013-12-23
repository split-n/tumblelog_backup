# encoding:utf-8
class ImagePost < Post
  def save
    store_obj.save_photo(detect_larger_image_urls,id)
  end

  def extension
    File.extname(detect_larger_image_urls.first)
  end

  private
  def detect_larger_image_urls
    # 良質なものから順に配列で複数urlを返す
    # urlがあっても取得できない場合があるので
    photos = @data["photos"][0]
    original_size = photos["original_size"]
    alt_sizes = photos["alt_sizes"]
    alt_maxes = alt_sizes.sort_by{|img| -(img["width"] * img["height"]) }.take(2)

    images = []
    images << original_size["url"] if original_size
    images.concat(alt_maxes.map{|p| p["url"] } ) 

    images
  end
end

