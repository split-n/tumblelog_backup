# encoding:utf-8
require 'open-uri'
class SaveStore
  def initialize(host)
    @save_dir = File.expand_path(File.dirname($0)) + "/#{host}/"
    FileUtils.mkdir_p("#{@save_dir}json/")
  end

  def save_quote(hash)

  end

  def save_photo(hash)
    dir = "#{@save_dir}image/"
    FileUtils.mkdir_p(dir)
  end



end
