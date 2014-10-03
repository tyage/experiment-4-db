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
    - emailにuniqueを指定することで、email -> id, name, passwordの関数従属性が保持される
- seller
    - idにprimary keyを指定することで第二正規形が保持できる
    - emailにuniqueを指定することで、email -> id, name, passwordの関数従属性が保持される
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

「課題１,２,３で設計したデータベースを実際にSQLiteで構築し，SQLによる検索文を作成する．」とあったため、SQLiteで定義しました。

```sql
CREATE TABLE buyer (
  id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
  email varchar(255) NOT NULL UNIQUE,
  name varchar(255) NOT NULL,
  password varchar(255) NOT NULL
);
CREATE TABLE seller (
  id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
  email varchar(255) NOT NULL UNIQUE,
  name varchar(255) NOT NULL,
  password varchar(255) NOT NULL
);
CREATE TABLE product (
  id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
  seller_id integer NOT NULL,
  name varchar(255) NOT NULL,
  cost integer NOT NULL,
  FOREIGN KEY (seller_id) REFERENCES seller (id)
);
CREATE TABLE "order" (
  id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
  buyer_id integer NOT NULL,
  product_id integer NOT NULL,
  created_at timestamp NOT NULL,
  FOREIGN KEY (buyer_id) REFERENCES buyer (id),
  FOREIGN KEY (product_id) REFERENCES product (id)
);
CREATE TABLE category (
  id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
  name varchar(255) NOT NULL
);
CREATE TABLE product_category (
  id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
  category_id integer NOT NULL,
  product_id integer NOT NULL,
  FOREIGN KEY (category_id) REFERENCES category (id),
  FOREIGN KEY (product_id) REFERENCES product (id)
);
```

関数従属性が保持されている

## 3. データを作成して，上記の表に挿入

### データを挿入

```sql
insert into buyer (email, name, password) values ('example@example.com', 'test', '*****');
insert into category (name) values ('本'), ('食料品'), ('電化製品');
insert into product (seller_id, name, cost) values (1, '鮭の切り身', 100), (1, '鮭のムニエル', 200), (1, '鮭のおにぎり', 100);
insert into seller (email, name, password) values ('seller1@example.com', 'seller1', '********');
```

### データを表示

```sql
select * from buyer;

1|example@example.com|test|*****
```
