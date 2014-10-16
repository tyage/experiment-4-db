# 最終レポート

- 工学部情報学科3回
- {student-name}
- {student-id}

## システム概要

### システムの説明

ショッピングサイト

商品販売者には販売商品の管理用のプラットフォームを、商品購入者には商品一覧表示や商品購入用のサービスを提供する。

商品は販売者が任意に追加・編集でき、各商品ごとに価格や商品名を設定する。

### 機能一覧

- 全体用
    - 商品販売者一覧表示
        - 商品販売者を一覧で表示します
    - 商品販売者詳細表示
        - 商品販売者の名前、メールアドレスを表示します
    - 販売商品一覧表示
        - 指定した商品販売者の販売している商品を一覧で表示します
    - 商品一覧表示
        - 商品を一覧で表示します
    - 商品詳細表示
        - 指定した商品の商品名・販売者・価格・カテゴリ情報を表示します
    - カテゴリ一覧表示
        - カテゴリを一覧で表示します
    - カテゴリ別商品一覧表示
        - 指定したカテゴリに属している商品を一覧で表示します
- 商品購入者用
    - 商品購入
        - 指定した商品を購入します
    - 購入履歴一覧表示
        - 過去にユーザが購入した商品を表示します
    - 新規登録
        - 商品購入者情報を新規に登録します
    - サインイン
        - 商品購入者idとpasswordを入力してサインインします
    - サインアウト
        - 商品購入者セッションを削除しサインアウトします
    - マイページ
        - サインインしているユーザの情報を表示します
    - アカウント設定
        - サインインしているユーザの情報を更新します
- 商品販売者用
    - 商品一覧表示
        - ユーザの販売している商品一覧を表示します
    - 商品追加
        - ユーザの販売商品を追加します
    - 商品情報更新
        - ユーザの販売している、指定した商品の情報を更新します
    - 販売履歴
        - ユーザの販売している、過去に購入された商品と購入者を一覧で表示します
    - 商品別販売履歴
        - ユーザの販売している、指定した商品の販売履歴を一覧で表示します
    - 購入者詳細表示
        - 購入者の名前、メールアドレスを表示します
    - 新規登録
        - 商品販売者情報を新規に登録します
    - サインイン
        - 商品販売者idとpasswordを入力してサインインします
    - サインアウト
        - 商品販売者セッションを削除しサインアウトします
    - マイページ
        - サインインしているユーザの情報を表示します
    - アカウント設定
        - サインインしているユーザの情報を更新します

## 実体関連図

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task2/er.png)

- buyer: 購入者
- seller: 販売者
- order: 注文
- product: 商品
- product_category: 商品とカテゴリの関係
- category: カテゴリ

## 関係スキーマ

### buyers

購入者テーブル

- id: id
- email: メールアドレス
- name: 購入者名
- password: ログイン用パスワード

```sql
sqlite> select id, email, name, encrypted_password from buyers;
id          email               name        encrypted_password
----------  ------------------  ----------  ------------------------------------------------------------
1           buyer1@example.com  buyer1      $2a$10$LwQNsuXRP2MT0mL0/FhV/.mZmfjBrOmHiBi2MgxoBgsz3SNVFvR9O
```

### sellers

販売者テーブル

- id: id
- email: メールアドレス
- name: 販売者名
- password: ログイン用パスワード

```sql
sqlite> select id, email, name, encrypted_password from sellers;
id          email                name        encrypted_password
----------  -------------------  ----------  ------------------------------------------------------------
1           example@example.com  amaz0n      $2a$10$yKRC60BDFzzP0rZ2c.rL/OJ3f2VXTFTNEFL5jBAOCfKI9OrmqKGj6
```

### orders

注文テーブル

- id: id
- buyer_id: 購入者id
- product_id: 商品id
- created_at: 注文日時

```sql
sqlite> select id, buyer_id, product_id, created_at from orders;
id          buyer_id    product_id  created_at
----------  ----------  ----------  --------------------------
1           1           1           2014-10-10 02:38:16.410485
5           1           2           2014-10-10 02:54:17.364471
7           1           1           2014-10-10 03:43:10.852484
8           1           1           2014-10-10 03:44:25.620149
9           1           1           2014-10-10 04:16:59.032564
10          1           3           2014-10-10 06:47:41.326692
```

### products

商品テーブル

- id: id
- seller_id: 販売者id
- name: 商品名
- cost: 商品価格

```sql
sqlite> select id, seller_id, cost, name from products;
id  seller_id   cost        name
--  ----------  ----------  ------------------------------
1   1           101         絵本
2   1           200         オリーブオイル
3   1           200         秋刀魚の塩焼き
```

### product_categories

商品カテゴリテーブル

- id: id
- category_id: カテゴリid
- product_id: 商品id

```sql
sqlite> select id, category_id, product_id from product_categories;
id          category_id  product_id
----------  -----------  ----------
3           1            1
4           2            2
5           3            2
6           2            3
```

### categories

カテゴリテーブル

- id: id
- name: カテゴリ名

```sql
sqlite> select id, name from categories;
id          name
----------  --------------------
1           本
2           食料品
3           電化製品
```

## 機能・インターフェイス

### 全体用

#### 商品販売者一覧表示

商品販売者を一覧で表示します

関係しているテーブル: sellers

```sql
  Seller Load (0.2ms)  SELECT "sellers".* FROM "sellers"
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/sellers.png)

#### 商品販売者詳細表示

商品販売者の名前、メールアドレスを表示します

関係しているテーブル: sellers

```sql
  Seller Load (0.1ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."id" = ? LIMIT 1  [["id", 1]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-show.png)

#### 販売商品一覧表示

指定した商品販売者の販売している商品を一覧で表示します

関係しているテーブル: sellers, products, categories, product_categories

```sql
  Seller Load (0.1ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."id" = ? LIMIT 1  [["id", 1]]
  Product Load (0.1ms)  SELECT "products".* FROM "products"  WHERE "products"."seller_id" = ?  [["seller_id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 2]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 3]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-product.png)

#### 商品一覧表示

商品を一覧で表示します

関係しているテーブル: sellers, products, categories, product_categories

```sql
  Product Load (0.2ms)  SELECT "products".* FROM "products"
  Seller Load (0.1ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."id" = ? LIMIT 1  [["id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 2]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 3]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/products.png)

#### 商品詳細表示

指定した商品の商品名・販売者・価格・カテゴリ情報を表示します

関係しているテーブル: sellers, products, categories, product_categories

```sql
  Product Load (0.1ms)  SELECT  "products".* FROM "products"  WHERE "products"."id" = ? LIMIT 1  [["id", 3]]
  Seller Load (0.1ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."id" = ? LIMIT 1  [["id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 3]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/product-show.png)

#### カテゴリ一覧表示

カテゴリを一覧で表示します

関係しているテーブル: categories

```sql
  Category Load (0.2ms)  SELECT "categories".* FROM "categories"
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/categories.png)

#### カテゴリ別商品一覧表示

指定したカテゴリに属している商品を一覧で表示します

関係しているテーブル: sellers, products, categories, product_categories

```sql
  Category Load (0.2ms)  SELECT  "categories".* FROM "categories"  WHERE "categories"."id" = ? LIMIT 1  [["id", 2]]
  Product Load (0.1ms)  SELECT "products".* FROM "products" INNER JOIN "product_categories" ON "products"."id" = "product_categories"."product_id" WHERE "product_categories"."category_id" = ?  [["category_id", 2]]
  Seller Load (0.1ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."id" = ? LIMIT 1  [["id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 2]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 3]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/category-show.png)

### 商品購入者用

#### 商品購入

指定した商品を購入します

関係しているテーブル: orders

```sql
  SQL (0.4ms)  INSERT INTO "orders" ("buyer_id", "created_at", "product_id", "updated_at") VALUES (?, ?, ?, ?)  [["buyer_id", 1], ["created_at", "2014-10-16 06:21:50.473507"], ["product_id", 2], ["updated_at", "2014-10-16 06:21:50.473507"]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/order-new.png)

#### 購入履歴一覧表示

過去にユーザが購入した商品を表示します

関係しているテーブル: orders, products

```sql
  Order Load (0.1ms)  SELECT "orders".* FROM "orders"  WHERE "orders"."buyer_id" = ?  [["buyer_id", 1]]
  Product Load (0.1ms)  SELECT  "products".* FROM "products"  WHERE "products"."id" = ? LIMIT 1  [["id", 1]]
  Product Load (0.1ms)  SELECT  "products".* FROM "products"  WHERE "products"."id" = ? LIMIT 1  [["id", 2]]
  Product Load (0.1ms)  SELECT  "products".* FROM "products"  WHERE "products"."id" = ? LIMIT 1  [["id", 3]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/orders.png)

#### 新規登録

商品購入者情報を新規に登録します

関係しているテーブル: buyers

```sql
   (0.1ms)  begin transaction
  Buyer Exists (0.2ms)  SELECT  1 AS one FROM "buyers"  WHERE "buyers"."email" = 'buyer2@example.com' LIMIT 1
  SQL (0.9ms)  INSERT INTO "buyers" ("created_at", "email", "encrypted_password", "updated_at") VALUES (?, ?, ?, ?)  [["created_at", "2014-10-16 06:28:27.257608"], ["email", "buyer2@example.com"], ["encrypted_password", "$2a$10$qYvenv4s0KKjYdOMRAayHu5vxtTRyjn40zkodoQZbQRSHUlcd1fQ."], ["updated_at", "2014-10-16 06:28:27.257608"]]
   (8.8ms)  commit transaction
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/buyer-new.png)

#### サインイン

商品購入者idとpasswordを入力してサインインします

関係しているテーブル: buyers

```sql
  Buyer Load (0.4ms)  SELECT  "buyers".* FROM "buyers"  WHERE "buyers"."email" = 'buyer2@example.com'  ORDER BY "buyers"."id" ASC LIMIT 1
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/buyer-sign-in.png)

#### サインアウト

商品購入者セッションを削除しサインアウトします

関係しているテーブル: なし

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/buyer-sign-out.png)

#### マイページ

サインインしているユーザの情報を表示します

関係しているテーブル: buyers

```sql
  Buyer Load (0.1ms)  SELECT  "buyers".* FROM "buyers"  WHERE "buyers"."id" = ? LIMIT 1  [["id", 2]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/buyer-show.png)

#### アカウント設定

サインインしているユーザの情報を更新します

関係しているテーブル: buyers

```sql
   (0.1ms)  begin transaction
  SQL (0.6ms)  UPDATE "buyers" SET "name" = ?, "updated_at" = ? WHERE "buyers"."id" = 2  [["name", "購入者2"], ["updated_at", "2014-10-16 06:38:11.722874"]]
   (8.9ms)  commit transaction
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/buyer-edit.png)

### 商品販売者用

#### 商品一覧表示

ユーザの販売している商品一覧を表示します

関係しているテーブル: sellers, products, categories, product_categories

```sql
  Seller Load (0.1ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."id" = ? LIMIT 1  [["id", 1]]
  Product Load (0.1ms)  SELECT "products".* FROM "products"  WHERE "products"."seller_id" = ?  [["seller_id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 1]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 2]]
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 3]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-product.png)

#### 商品追加

ユーザの販売商品を追加します

関係しているテーブル: categories, products, product_categories

```sql
   (0.1ms)  begin transaction
  SQL (0.3ms)  INSERT INTO "products" ("cost", "created_at", "name", "seller_id", "updated_at") VALUES (?, ?, ?, ?, ?)  [["cost", 300], ["created_at", "2014-10-16 06:44:41.636677"], ["name", "キムワイプ"], ["seller_id", 1], ["updated_at", "2014-10-16 06:44:41.636677"]]
  SQL (0.2ms)  INSERT INTO "product_categories" ("category_id", "created_at", "product_id", "updated_at") VALUES (?, ?, ?, ?)  [["category_id", 2], ["created_at", "2014-10-16 06:44:41.638155"], ["product_id", 4], ["updated_at", "2014-10-16 06:44:41.638155"]]
   (9.0ms)  commit transaction
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/product-new.png)

#### 商品情報更新

ユーザの販売している、指定した商品の情報を更新します

関係しているテーブル: categories, products, product_categories

```sql
   (0.1ms)  begin transaction
  Category Load (0.2ms)  SELECT "categories".* FROM "categories"  WHERE "categories"."id" IN (2, 3)
  Category Load (0.1ms)  SELECT "categories".* FROM "categories" INNER JOIN "product_categories" ON "categories"."id" = "product_categories"."category_id" WHERE "product_categories"."product_id" = ?  [["product_id", 4]]
  SQL (0.2ms)  INSERT INTO "product_categories" ("category_id", "created_at", "product_id", "updated_at") VALUES (?, ?, ?, ?)  [["category_id", 3], ["created_at", "2014-10-16 06:47:47.802098"], ["product_id", 4], ["updated_at", "2014-10-16 06:47:47.802098"]]
  SQL (0.1ms)  UPDATE "products" SET "cost" = ?, "updated_at" = ? WHERE "products"."id" = 4  [["cost", 308], ["updated_at", "2014-10-16 06:47:47.803274"]]
   (8.9ms)  commit transaction
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/product-edit.png)

#### 販売履歴

ユーザの販売している、過去に購入された商品と購入者を一覧で表示します

関係しているテーブル: product, orders, buyers

```sql
  Product Load (0.1ms)  SELECT "products".* FROM "products"  WHERE "products"."seller_id" = ?  [["seller_id", 1]]
  Order Load (0.1ms)  SELECT "orders".* FROM "orders"  WHERE "orders"."product_id" = ?  [["product_id", 1]]
  Order Load (0.0ms)  SELECT "orders".* FROM "orders"  WHERE "orders"."product_id" = ?  [["product_id", 2]]
  Order Load (0.1ms)  SELECT "orders".* FROM "orders"  WHERE "orders"."product_id" = ?  [["product_id", 3]]
  Order Load (0.0ms)  SELECT "orders".* FROM "orders"  WHERE "orders"."product_id" = ?  [["product_id", 4]]
  Buyer Load (0.1ms)  SELECT  "buyers".* FROM "buyers"  WHERE "buyers"."id" = ? LIMIT 1  [["id", 1]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-sold.png)

#### 商品別販売履歴

ユーザの販売している、指定した商品の販売履歴を一覧で表示します

関係しているテーブル: product, orders, buyers

```sql
  Product Load (0.1ms)  SELECT  "products".* FROM "products"  WHERE "products"."id" = ? LIMIT 1  [["id", 2]]
  Order Load (0.1ms)  SELECT "orders".* FROM "orders"  WHERE "orders"."product_id" = ?  [["product_id", 2]]
  Buyer Load (0.0ms)  SELECT  "buyers".* FROM "buyers"  WHERE "buyers"."id" = ? LIMIT 1  [["id", 1]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/product-sold.png)

#### 購入者詳細表示

購入者の名前、メールアドレスを表示します

関係しているテーブル: buyers

```sql
  Buyer Load (0.1ms)  SELECT  "buyers".* FROM "buyers"  WHERE "buyers"."id" = ? LIMIT 1  [["id", 1]]
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/buyer-show.png)

#### 新規登録

商品販売者情報を新規に登録します

関係しているテーブル: sellers

```sql
   (0.1ms)  begin transaction
  Seller Exists (0.1ms)  SELECT  1 AS one FROM "sellers"  WHERE "sellers"."email" = 'seller2@example.com' LIMIT 1
Binary data inserted for `string` type on column `encrypted_password`
  SQL (0.3ms)  INSERT INTO "sellers" ("created_at", "email", "encrypted_password", "updated_at") VALUES (?, ?, ?, ?)  [["created_at", "2014-10-16 07:05:56.355784"], ["email", "seller2@example.com"], ["encrypted_password", "$2a$10$yqA4n5IeSPsqb3iy9D7L5O8TkuHzP75/vTldeiCnTiF7KXrYOGuqK"], ["updated_at", "2014-10-16 07:05:56.355784"]]
   (0.8ms)  commit transaction
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-new.png)

#### サインイン

商品販売者idとpasswordを入力してサインインします

関係しているテーブル: sellers

```sql
  Seller Load (0.5ms)  SELECT  "sellers".* FROM "sellers"  WHERE "sellers"."email" = 'seller2@example.com'  ORDER BY "sellers"."id" ASC LIMIT 1
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-sign-in.png)

#### サインアウト

商品販売者セッションを削除しサインアウトします

関係しているテーブル: なし

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/seller-sign-out.png)

#### マイページ

サインインしているユーザの情報を表示します

関係しているテーブル:

```sql
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/.png)

#### アカウント設定

サインインしているユーザの情報を更新します

関係しているテーブル:

```sql
```

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task-final/screenshots/.png)

## 工夫点

## 感想
