# encoding:utf-8
require 'open-uri'
require_relative './loader'

class SaveFailedError < RuntimeError ; end



class SaveStore
  Save_each_obj_type = [:photo,:video,:audio]
  class SaveDir
    def initialize(root)
      @root_dir = File.expand_path(root)

    end

    def for_data(type)
      if Save_each_obj_type.include? type
        "#{@root_dir}/#{type}/#{type}"
      else 
        nil
      end
    end
    
    def for_json(type)
      "#{@root_dir}/#{type}/json"
    end
  end

  def initialize(save_root_dir)
    @save_root_dir =  File.expand_path(save_root_dir)
    @save_root_dir.concat('/') unless @save_root_dir.end_with?('/')
  end

  def create_save_root_dirs
    SaveStore.TYPES.each do |type|
      root_for_type = "#{@save_root_dir}#{type}/"
      if Save_each_obj_type.include? type
        FileUtils.mkdir_p("#{root_for_type}#{type}/")
      end
      FileUtils.mkdir_p("#{root_for_type}json/")
    end
  end

  def save(post)
    case post
    when PhotoPost
      save_photo(post)
    end
  end


  private

  def save_json(hash,filename_without_extension)
    json = JSON.generate(hash)
    File.write("#{@save_root_dir}json/#{filename_without_extension}.json",json)
  end

  def save_quote(hash)

  end

  def save_photo(post)

  end

end

