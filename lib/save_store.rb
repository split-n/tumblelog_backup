# encoding:utf-8
require 'open-uri'
class SaveStore
  def initialize(host)
    @save_dir = File.expand_path(File.dirname($0)) + "/save/#{host}/"
    FileUtils.mkdir_p("#{@save_dir}json/")
  end

  def save_json(hash,filename_without_extension)
    

  end

  def save_quote(hash)

  end

  def save_photo(image_urls,filename_without_extension)
    dir = "#{@save_dir}image/"
    FileUtils.mkdir_p(dir)
    
    largest_img_url = image_urls.find {|image_url|
      result = try_open_url(image_url)
      next false unless result
      next false if result.size < 1024*2 # less than 2KB
      true
    }

    extension = File.extname(largest_img_url)

    image = open(largest_img_url).read


    File.binwrite("#{dir}#{filename_without_extension}#{extension}",image)

    
  end

  def try_open_url(url)
    res = open(url)
    res

  rescue
    return false
  end



end
