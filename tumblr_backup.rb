#!/usr/bin/env ruby
# encoding:utf-8
require 'bundler'
require 'optparse'
require_relative './lib/tumblr_backup_runner.rb'
require 'logger'

State_file_path = File.expand_path(__dir__) + "/resume.json"
Api_key_file_path = File.expand_path(__dir__) + "/apikey.yml"
Dest_dir = File.expand_path(__dir__) + "/save/"
LogFile_path = File.expand_path(__dir__) + "/error.log"

def parse_options(argv=ARGV)
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

## BEGIN MAIN

logger = Logger.new(LogFile_path)
logger.progname = "TumblrBackup"

begin
runner = TumblrBackupRunner.new(parse_options,State_file_path,Api_key_file_path,Dest_dir,logger)
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
rescue TumblrBackupRunner::ApiKeyLoadFailedError
  warn <<-'EOF'
  apikey.yml is missing or something wrong.
  Please read README.md.
  EOF
  exit(1)
rescue TumblrBackupRunner::StateFileLoadFailedError
  warn <<-'EOF'
  State file(state.json) is missing or something wrong.
  EOF
end

[:INT,:TERM,:HUP].each do |sig|
  Signal.trap(sig) do
    runner.exit! {
      puts "#{sig} detected,saving state to file and going to exit."
    }
  end
end

runner.every_dl_completed_proc = proc{|post,path|
  puts "saved #{post.id} to #{path}"
}

runner.every_dl_failed_proc = proc{|post|
  warn "failed to save #{post.id}"
}

runner.save_all!







