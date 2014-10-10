計算機科学実験演習用デモアプリケーション
==================

Requirements
------------

- Ruby 2.1.2p95
- Bundler 1.7.2
- SQLite 3.7.13

## How to start development

### 1. Check your ruby and bundler version

```bash
$ ruby -v # ruby 2.1.2p95
$ bundle -v # Bundler version 1.7.2
```

### 2. Clone this repository and install gems

```bash
$ git clone ${REPOSITORY_PATH}
$ cd experiment-4/sample-app
$ bundle install --path vendor/bundle
```

### 3. Setup database

edit `config/database.yml`

```bash
$ ./bin/rake db:create
$ ./bin/rake db:migrate
$ ./bin/rake db:seed
```

### 4. Run rails server

```bash
$ ./bin/rails s
```

Then open `http://localhost:3000/` in your browser.
