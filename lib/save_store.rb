# encoding:utf-8
require 'open-uri'
require_relative './loader'

class SaveFailedError < RuntimeError ; end

class SaveStore

  def initialize(save_root_dir)
    @save_root_dir =  File.expand_path(save_root_dir)
    @save_root_dir.concat('/') unless @save_root_dir.end_with?('/')
    create_save_root_dirs
  end

  def create_save_root_dirs
    FileUtils.mkdir_p("#{@save_root_dir}json/")
    PostFactory::TYPES.each do |type|
      FileUtils.mkdir_p("#{@save_root_dir}#{type}/")
    end
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
    File.write("#{@save_root_dir}json/#{post.id}.json",post.json)
  end

  def save_photo(post)
    filename = "#{post.id}#{post.extension}"
    File.binwrite("#{@save_root_dir}photo/#{filename}",post.photo.read)
  end

end

