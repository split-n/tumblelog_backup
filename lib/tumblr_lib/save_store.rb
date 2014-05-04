# encoding:utf-8
require 'open-uri'
require_relative './save_directory.rb'
require_relative './posts_loader.rb'

class SaveFailedError < RuntimeError ; end

class SaveStore
  def initialize(save_root_dir,split_json_dir)
    @dir = SaveDirectory.new(save_root_dir,split_json_dir)
  end

  def save(post)
    case post
    when PhotoPost
      save_photo(post)
    end
    save_json(post)
  end

  private
  def save_json(post)
    File.write("#{@dir.for_json[post.type]}/#{post.id}.json",post.json)
  end

  def save_photo(post)
    filename = "#{post.id}#{post.extension}"
    File.binwrite("#{@dir.for_content[post.type]}/#{filename}",post.photo.read)
  end

end

