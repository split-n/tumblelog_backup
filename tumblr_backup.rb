#!/usr/bin/env ruby
# encoding:utf-8
require 'bundler'
require 'optparse'
require 'yaml'
require_relative 'lib/loader.rb'

class TumblrBackupCli

  class ApiKeyLoadFailedError < StandardError;end
  class StateFileLoadFailedError < StandardError;end

  def initialize(argv,state_file_path,api_key_file_path,default_dest_dir)
    @options = parse_options(argv)
    require_gems
    api_key = load_api_key(api_key_file_path)
    @state_file_path = state_file_path

    if @options[:resume]
      state = load_state_file(state_file_path)
      @options[:dest_dir] = state[:dest_dir]
      @options[:split_json] = state[:split_json]
      @tl = ResumableTumblelog.restore(state[:tumblelog],api_key)
    else
      @options[:dest_dir] ||= default_dest_dir
      @tl = ResumableTumblelog.new(@options[:account],api_key)
    end

  @store = SaveStore.new(@options[:dest_dir],!!@options[:split_json])
  @called_when_per_dl_finished = proc{}
  end

  def save_all!
    @tl.each_post do |post|
      begin
        @store.save(post)
        puts "download #{post.id}"
        @called_when_per_dl_finished.call
      rescue SaveFailedError
        puts "save failed: #{post.id}"
      end
    end
  end


  # これを実行すると、現在進行中のものをダウンロード後に
  # blockを実行して終了する
  def exit! 
    @called_when_per_dl_finished = proc {
      yield
      save_state_to_file
      exit(0)
    }
  end


  private
  def save_state_to_file
    tl_state = @tl.save_state
    state = {
      dest_dir: @options[:dest_dir],
      split_json: @options[:split_json],
      tumblelog: tl_state
    }
    File.write(@state_file_path,JSON.generate(state))
    nil
  end

  def parse_options(argv)
    options = {}
    OptionParser.new do |parser|
      parser.on('-d','--development') {options[:development] = true }
      parser.on('-a','--account ACCOUNT') {|v| options[:account] = v }
      parser.on('-o','--output DEST_DIR') {|v| options[:dest_dir] = v }
      parser.on('-s','--split-json') {options[:split_json] = true }
      parser.on('-r','--resume') {options[:resume] = true }
      parser.parse!(argv)
    end

    # 片方だけ
    unless options.has_key?(:resume) ^ options.has_key?(:account)
      raise ArgumentError 
    end

    options
  end

  def require_gems
    if @options[:development]
      Bundler.require(:default,:development)
    else
      Bundler.require
    end
  end

  def load_api_key(api_key_file_path)
    required_keys = [:consumer_key,:consumer_secret,
                    :oauth_token,:oauth_token_secret]

    begin
      key = YAML.load_file(api_key_file_path)
      key_symbolized = key.each_with_object({}){|(k,v),obj| obj[k.to_sym] = v}
      raise  unless required_keys.all?{|k| key_symbolized.has_key?(k) }
    rescue
      raise ApiKeyLoadFailedError
    end

    key_symbolized
  end

  def load_state_file(state_file_path)
    required_keys = [:dest_dir,:split_json,:tumblelog]
    state_json = open(state_file_path).read
    resume_state = JSON.parse(state_json,symbolize_names:true)

    raise StateFileLoadFailedError unless required_keys.all?{|k| resume_state.has_key?(k) }

    resume_state
  end


end

State_file_path = File.expand_path(__dir__) + "/resume.json"
Api_key_file_path = File.expand_path(__dir__) + "/apikey.yml"
Dest_dir = File.expand_path(__dir__) + "/save/"

begin
cli = TumblrBackupCli.new(ARGV,State_file_path,Api_key_file_path,Dest_dir)
rescue ArgumentError
  warn <<-'EOF'
  Basic Usage: ./tumblr_backup.rb -a SAVE_TARGET_NAME_OR_DOMAIN [-o OUTPUT_DIR] [-s ] 
  Options in [ ] is optional.
    -o : specify save directory.
    -s : to split json saving folder.

  Resume Usage: ./tumblr_backup.rb -r 
    -r : resume from latest saved state.
  EOF
  exit(1)
rescue TumblrBackupCli::ApiKeyLoadFailedError
  warn <<-'EOF'
  apikey.yml is missing or something wrong.
  Please read README.md.
  EOF
  exit(1)
rescue TumblrBackupCli::StateFileLoadFailedError
  warn <<-'EOF'
  State file(state.json) is missing or something wrong.
  EOF
end

Signal.trap(:INT) do
  cli.exit! {
    puts "SIGINT detected,saving to state file."
  }
end

cli.save_all!







