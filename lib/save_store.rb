class SaveStore
  def initialize(host)
    @save_dir = ""./#{host}/"
    FileUtils.mkdir_p("#{@save_dir}json/")
  end

  def save_quote(json)

  end

  def save_photo(json)
    dir = "#{@save_dir}image/"
    FileUtils.mkdir_p(dir)
  end

end
