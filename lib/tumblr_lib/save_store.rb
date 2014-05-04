# encoding:utf-8
require 'open-uri'
require_relative './save_directory.rb'
require_relative './posts_loader.rb'

class SaveStore
  def initialize(save_root_dir,split_json_dir)
    @dir = SaveDirectory.new(save_root_dir,split_json_dir)
  end

  def save(post)
    saved_path = save_json(post)
    case post
    when PhotoPost
      save_photo(post)
    else
      saved_path # just returns json's path
    end
  end

  private
  def save_json(post)
    path = "#{@dir.for_json[post.type]}/#{post.id}.json"
    File.write(path,post.json)
    path
  end

  def save_photo(post)
    filename = "#{post.id}#{post.extension}"
    path = "#{@dir.for_content[post.type]}/#{filename}"
    File.binwrite(path,post.photo.read)
    path
  end

end

