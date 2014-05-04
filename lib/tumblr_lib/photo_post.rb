# encoding:utf-8
require_relative './post.rb'
class PhotoPost < Post
  def extension
    image_data[2]
  end

  def photo
    image_data[1]
  end


  private

  # should use this method instead of @image_data
  # struct : [url,File]
  def image_data
    unless @image_data
      @image_data = image_urls.lazy.map {|url|
        result = try_open_url(url)
        if result
          extension = File.extname(url)
          if extension == ""
            extension = image_urls.map{|l| File.extname(l)}.find{|ex| ex != ""}
            raise if extension == ""
          end
          [url,result,extension]
        else
          nil
        end
      }.reject(&:nil?).first
    end
    return @image_data
  end

  # sorted by image size desc
  def image_urls
    photos = @data["photos"][0]
    original_size = photos["original_size"]
    alt_sizes = photos["alt_sizes"]
    alt_maxes = alt_sizes.sort_by{|img| -(img["width"] * img["height"]) }

    images = []
    images << original_size["url"] if original_size
    images.concat(alt_maxes.map{|p| p["url"] } )

    images
  end

  def try_open_url(url)
    open(url)
  rescue
    return false
  end

end

