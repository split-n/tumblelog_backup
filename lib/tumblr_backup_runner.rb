require 'bundler'
require 'yaml'
require 'logger'
require_relative './libs_loader.rb'

class TumblrBackupRunner
  attr_accessor :every_dl_completed_proc,:every_dl_failed_proc

  class ApiKeyLoadFailedError < StandardError;end
  class StateFileLoadFailedError < StandardError;end

  def initialize(options,state_file_path,api_key_file_path,default_dest_dir,logger)
    @options = options
    require_gems
    api_key = load_api_key(api_key_file_path)
    @state_file_path = state_file_path
    @logger = logger

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
    @after_every_post = proc{
      save_state_to_file
      }

    @every_dl_completed_proc = proc{}
    @every_dl_failed_proc = proc{}
  end

  def save_all!
    @tl.each_post do |post|
      begin
        saved_path = @store.save(post)
        @every_dl_completed_proc.call(post,saved_path)
      rescue => e
        @every_dl_failed_proc.call(post)
        log_exception(post,e)
        binding.pry if @options[:development]
      ensure
        @after_every_post.call
      end
    end
    nil
  end


  # これを実行すると、現在進行中のものをダウンロード後に
  # blockを実行して終了する
  def exit! 
    @after_every_post = proc {
      yield
      save_state_to_file
      exit(0)
    }
  end


  private
  def log_exception(post,ex)
    msg = <<"EOF"
error at #{post.id}
#{ex.inspect}
#{ex.backtrace}
EOF
    @logger.error(msg)
  end

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
