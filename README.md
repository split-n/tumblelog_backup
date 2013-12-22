## Tumblelog Backup Tool

TumblrのTumblelogをバックアップできるツール(予定)  
現状画像だけダウンロードできます

### how to use
`$ git clone https://github.com/split-n/tumblelog_backup `

[http://www.tumblr.com/docs/en/api/v2](http://www.tumblr.com/docs/en/api/v2)でアプリケーションを登録し、[http://gettumblraccesstoken.heroku.com/](http://gettumblraccesstoken.heroku.com/)でtokenを取得  
apikey.yml.sampleにそれぞれ書き込み、apikey.ymlとして保存

`$ bundle install --path vendor/bundle`  
`$ ruby main.rb -a your_account_name_or_domain`

