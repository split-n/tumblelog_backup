# encoding:utf-8
require 'open-uri'
class SaveStore
  def initialize(save_dir)
    @save_dir =  save_dir
    @save_dir.concat('/') unless @save_dir.end_with?('/')
    FileUtils.mkdir_p("#{@save_dir}json/")
    FileUtils.mkdir_p("#{@save_dir}image/")
  end

  def save_json(hash,filename_without_extension)
    json = JSON.generate(hash)
    File.write("#{@save_dir}json/#{filename_without_extension}.json",json)
  end

  def save_quote(hash)

  end

  def save_photo(image_urls,filename_without_extension)
    image_data = image_urls.lazy.map {|url|
      result = try_open_url(url)
      next false unless result
      next false if result.size < 1024*2 # less than 2KB
      next [url,result]
    }.first

    image = image_data[1]
    extension = File.extname(image_data[0])

    File.binwrite("#{@save_dir}image/#{filename_without_extension}#{extension}",image)

    
  end

  def try_open_url(url)
    open(url)
  rescue
    return false
  end



end
