# encoding:utf-8
require_relative './loader'

class SaveDirectory
  attr_reader :for_content, :for_json
  def initialize(save_root_path:,each_folder_json:false)
    p = File.expand_path(save_root_path)
    @root = p.end_with?('/') ? p : p + '/'
    @json_split = each_folder_json

    create_dirs
  end

  private
  def create_dirs
    @for_content = {}
    @for_json = {}
    if @json_split
      PostFactory::TYPES.each do |type|
        cp = @root + type.to_s + '/' + type.to_s
        FileUtils.mkdir_p(cp)
        @for_content[type] = cp.freeze

        jp = @root + type.to_s + '/json'
        FileUtils.mkdir_p(jp)
        @for_json[type] = jp.freeze
      end
    else
      jp = @root + 'json'
      FileUtils.mkdir_p(jp)
      PostFactory::TYPES.each do |type|
        cp = @root + type.to_s 
        FileUtils.mkdir_p(cp)
        @for_content[type] = cp.freeze
        @for_json[type] = jp.freeze
      end
    end
    @for_content.freeze
    @for_json.freeze
  end

end
