## 立ち上げ

docker立ち上げ
```
$ docker-compose build
$ docker-compose up
```

dbの作成
```
$ docker-compose exec rails bash
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

elasticsearchの設定
```
$ docker-compose exec rails bash
$ rails c
$ Article.__elasticsearch__.create_index!
# Article.__elasticsearch__.create_index! force:true
$ Article.__elasticsearch__.import
```

- 確認
  - http://localhost:3010/articles
  - http://localhost:5601/app/dev_tools#/console
  - http://localhost:9200/
  - `curl -XGET http://localhost:9200/`

## 環境構築参考
- Docker、Elasticsearch、Railsの環境構築
  - [DockerでRails,Postgres,ElasticSearchの開発環境を構築する方法 \- Qiita](https://qiita.com/yuki_0920/items/ae5a911e8327252c7ffa)

- [elasticsearch\-rails \| RubyGems\.org \| コミュニティのGemホスティングサービス](https://rubygems.org/gems/elasticsearch-rails)
- [elasticsearch\-model \| RubyGems\.org \| コミュニティのGemホスティングサービス](https://rubygems.org/gems/elasticsearch-model)
- [elasticsearch \| RubyGems\.org \| コミュニティのGemホスティングサービス](https://rubygems.org/gems/elasticsearch)
- [ElasticSearchClientを利用する際の注意点](https://zenn.dev/hajimeni/articles/682e81fa68c7af)

	```
	# 修正
	gem 'elasticsearch-rails', '~> 7.2'
	gem 'elasticsearch-model', '~> 7.2'
	gem 'elasticsearch', '~> 7.16', '>= 7.16.1'

	image: docker.elastic.co/elasticsearch/elasticsearch:7.16.1
	```

- `exited with code 137`
  - [Memory不足でElasticSearchのDockerコンテナ立ち上げが「exited with code 137」で終了したときの対応方法 \- Qiita](https://qiita.com/virtual_techX/items/50383184ff2e2e366e33)
    - Dockerのメモリを2GBに変更

- `A server is already running.`
  - [docker\-compose upしたときに「A server is already running\.」って言われないようにする \- Qiita](https://qiita.com/paranishian/items/862ce4de104992df48e1)
		- `/bin/sh -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"`に変更
 
- Railsの変更したコードが反映されない
	- [【Rails6】Dockerコンテナを再起動しないとソースコードが反映されない \- Qiita](https://qiita.com/Kiyo_Karl2/items/147d604e625b8a55e12e)
		- `config.file_watcher = ActiveSupport::FileUpdateChecker`

- dev_tools
	```
	#! Elasticsearch built-in security features are not enabled. Without authentication, your cluster could be accessible to anyone. See https://www.elastic.co/guide/en/elasticsearch/reference/7.16/security-minimal-setup.html to enable security.
	```
	- [Elasticsearchを導入してみた（Rails, Docker, AWS Elasticsearch Service） \- React Native Tech Blog](https://ducklings.hateblo.jp/entry/2018/05/01/211829)
  	- `- xpack.security.enabled=false`修正


## Elasticsearchの学習
- rails cでの確認
	- [docker\-composeでのRails環境にElasticsearchを組み込む \- ウェブエンジニア珍道中](https://www.te-nu.com/entry/2018/07/26/200722)

- rails c、kibanでの確認
	- [Elasticsearchをたくさんやった年なのでチュートリアルを紹介する \- Qiita](https://qiita.com/k-waragai/items/c6145c965f79a13b9093)

- [Rails × Amazon Elasticsearch Serviceで全文検索 \- LCL Engineers' Blog](https://techblog.lclco.com/entry/2020/12/16/133521)
	```
	result = Article.search("記事本文_3")
	result.results.total
	=> 5

	result = Article.search("_3")
	result.results[0].body
	```

- 簡単な実装
	- [RailsアプリでElasticsearchを扱う](https://tech.pla-cole.co/rails%E3%82%A2%E3%83%97%E3%83%AA%E3%81%A7elasticsearch%E3%82%92%E6%89%B1%E3%81%86/)
		- `Elasticsearch::Transport::Transport::Errors::NotFound in ArticlesController#index`
			- 修正
				- `index_name "articles"`
		- エラー
			```
			$ Article.__elasticsearch__.create_index!

			Elasticsearch::Transport::Transport::Errors::BadRequest ([400] {"error":{"root_cause":[{"type":"mapper_parsing_exception","reason":"No handler for type [string] declared on field [title]"}],"type":"mapper_parsing_exception","reason":"Failed to parse mapping [_doc]: No handler for type [string] declared on field [title]","caused_by":{"type":"mapper_parsing_exception","reason":"No handler for type [string] declared on field [title]"}},"status":400})
			```
			- `indexes :title, type: 'text'`に修正


- 完全一致検索の実装
	- [Elasticsearchで部分一致検索と完全一致検索の両方を実現する \- Qiita](https://qiita.com/mctk/items/0a072e758811d90d4642)

- [初心者のためのElasticsearchその2 \-いろいろな検索\- \| DevelopersIO](https://dev.classmethod.jp/articles/es-02/)
	```
	GET articles/_search
	{
		"query": {
			"match": { "body" : "記事本文0"}
		},
		"_source" : ["title","body"]
	}
	```

## 後で
- あいまい検索
	- [Elasticsearchのfuzzy queryを使って、あいまい検索を試してみる \- Qiita](https://qiita.com/EastResident/items/5ebdd5d301838fd1be24)

- JOIN
	- [ZOZOTOWNの検索基盤におけるElasticsearch移行で得た知見 \- ZOZO TECH BLOG](https://techblog.zozo.com/entry/migrating-zozotown-search-platform)

- [セキュリティ機能のはじめ方 \| Elastic Blog](https://www.elastic.co/jp/blog/getting-started-with-security)
