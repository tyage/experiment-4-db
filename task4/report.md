# 課題4

- 工学部情報学科3回
- {student-name}
- {student-id}

課題１,２,３で設計したデータベースを実際にSQLiteで構築し，SQLによる検索文を作成する．

課題４のレポートを以下の内容についてまとめなさい．

1. 表の定義において，キーの指定により保持できる関数従属性や正規形について考察しなさい．
2. 課題３で設計した関係スキーマに基づいてPostgreSQLで表を定義しなさい．定義するためのSQL文を示しなさい．なお，各関数従属性が保持されることを文章で説明しなさい．
3. データを作成して，上記の表に挿入しなさい．データを挿入するためのSQL文を示しなさい．また，データを挿入した表の出力（先頭の一部で結構）を示しなさい．

## 1. 表の定義において，キーの指定により保持できる関数従属性や正規形について考察

- buyer
    - idにprimary keyを指定することで第二正規形が保持できる
- seller
    - idにprimary keyを指定することで第二正規形が保持できる
- order
    - idにprimary keyを指定することで第二正規形が保持できる
    - buyer_idにforeign keyを指定することで第三正規形が保持できる
    - product_idにforeign keyを指定することで第三正規形が保持できる
- product
    - idにprimary keyを指定することで第二正規形が保持できる
    - seller_idにforeign keyを指定することで第三正規形が保持できる
- product_category
    - idにprimary keyを指定することで第二正規形が保持できる
    - category_idにforeign keyを指定することで第三正規形が保持できる
    - product_idにforeign keyを指定することで第三正規形が保持できる
- category
    - idにprimary keyを指定することで第二正規形が保持できる

## 2. 課題３で設計した関係スキーマに基づいてPostgreSQLで表を定義

```sql
CREATE TABLE buyer (
  id SERIAL NOT NULL  PRIMARY KEY,
  email varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  password varchar(255) NOT NULL
);
CREATE TABLE seller (
  id SERIAL NOT NULL  PRIMARY KEY,
  email varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  password varchar(255) NOT NULL
);
CREATE TABLE product (
  id SERIAL NOT NULL  PRIMARY KEY,
  seller_id integer NOT NULL,
  name varchar(255) NOT NULL,
  cost integer NOT NULL,
  FOREIGN KEY (seller_id) REFERENCES seller (id)
);
CREATE TABLE "order" (
  id SERIAL NOT NULL  PRIMARY KEY,
  buyer_id integer NOT NULL,
  product_id integer NOT NULL,
  created_at timestamp NOT NULL,
  FOREIGN KEY (buyer_id) REFERENCES buyer (id),
  FOREIGN KEY (product_id) REFERENCES product (id)
);
CREATE TABLE category (
  id SERIAL NOT NULL  PRIMARY KEY,
  name varchar(255) NOT NULL
);
CREATE TABLE product_category (
  id SERIAL NOT NULL  PRIMARY KEY,
  category_id integer NOT NULL,
  product_id integer NOT NULL,
  FOREIGN KEY (category_id) REFERENCES category (id),
  FOREIGN KEY (product_id) REFERENCES product (id)
);
```

関数従属性が保持されている

## 3. データを作成して，上記の表に挿入

データを挿入

```sql
insert into buyer (email, name, password) values ('example@example.com', 'test', '*****');
```

データを表示

```sql
select * from buyer;

 id |        email        | name | password
----+---------------------+------+----------
  1 | example@example.com | test | *****
(1 row)
```
