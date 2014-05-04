## Tumblelog Backup Tool

TumblrのTumblelogをバックアップできるツール
現状では画像は画像ファイルをダウンロード、その他はjsonファイルのみをダウンロードする

### how to use
`$ git clone https://github.com/split-n/tumblelog_backup `

[http://www.tumblr.com/docs/en/api/v2](http://www.tumblr.com/docs/en/api/v2)でアプリケーションを登録し、  
[http://gettumblraccesstoken.heroku.com/](http://gettumblraccesstoken.heroku.com/)でtokenを取得  
apikey.yml.sampleにそれぞれ書き込み、apikey.ymlとして保存

`$ bundle install --path vendor/bundle`  

バックアップ開始:  
`$ bundle exec ruby tumblr_backup.rb -a your_account_name_or_domain`  
=> .rbと同じディレクトリのsave/[アカウント名]/ に保存される  
Ctrl+Cなどでプログラムを終了しても、後でリジュームが可能  
`$ bundle exec ruby tumblr_backup.rb -r`   
=> 前回の保存完了位置から保存
