# encoding:utf-8
require_relative './loader'

class SaveDirectory
  attr_reader :for_content, :for_json
  def initialize(save_root_path:,each_folder_json:false)
    @root = File.expand_path(save_root_path)
    @json_split = each_folder_json

    create_dirs
  end

  private
  def create_dirs
    @for_content = {}
    @for_json = {}
    if @json_split
      PostFactory::TYPES.each do |type|
        cp = File.join(@root,type.to_s + '/' + type.to_s)
        FileUtils.mkdir_p(cp)
        @for_content[type] = cp.freeze

        jp = File.join(@root,type.to_s + '/json')
        FileUtils.mkdir_p(jp)
        @for_json[type] = jp.freeze
      end
    else
      jp = File.join(@root, 'json')
      FileUtils.mkdir_p(jp)
      PostFactory::TYPES.each do |type|
        cp = File.join(@root, type.to_s)
        FileUtils.mkdir_p(cp)
        @for_content[type] = cp.freeze
        @for_json[type] = jp.freeze
      end
    end
    @for_content.freeze
    @for_json.freeze
  end


end
