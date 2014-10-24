# 課題6

- 工学部情報学科3回
- {student-name}
- {student-id}

追加課題の実施はPostgreSQL ( http://www.postgresql.org/ ) を利用したほうがよい．
設定などでつまづいた場合は，TAか教員に相談してください．

SQLによる選択などの検索において，索引による高速化が期待出来ると出来ない場合がある．
以下の課題を行い，索引の有効性について考察してください．
ただし，索引の種類は，ここではbtreeを指定するものとする．

課題６の関係インスタンスは，プログラムを作成して自動生成してください．
テキストファイルからデータベースにデータを投入するにはpsqlの"\COPY"コマンド*3*4を利用すると良いでしょう．
索引の効果をテストするために十分大きな組数の関係を生成する必要がありますが，共有サーバーを利用していることを考慮して組数を10万以下にしてください．

PostgreSQLでの検索時間の測定はコマンド"EXPLAIN"を利用できる．
EXPALIN ANALYZEを利用して，予測されるコストと実際の実行コストを出力して比較することができる．
レポートでは，以下の課題の予測コストと実際コストの両方を報告してください．

1. (キャッシュ) データベースではアクセスしたディスクのページを主記憶にキャッシュすることにより，同じ検索を再度実行したときの実行時間を短縮することができる．
１つの検索質問を設定して，検索を繰り返して実行し，キャッシュが有効な状況とそうでない状況を示してください．
また，キャッシュが効きにくい質問について考えてみてください．
以下の項目では，キャッシュなしという状況で比較してください．

2. (索引の有無) ある属性に対する選択質問について，その属性に索引を構築している場合と構築してない場合の検索時間の違いを，関係の組数を変化させて求めてください．
その結果について考察してください．
また，関係の属性数，組数や1つの組の大きさを変化させ，索引が効果的となる状況について考察してみること．
多くのDBMSでは主キーには自動で索引が構築されるため，主キー以外の属性を対象にするとよい．

3. (選択率) 1つの関係に対する選択質問で，質問の選択条件を満たす組の数を変化させる．
質問を満たす組がただ1つの場合と，満たす組の割合（選択率）0 < k < 1を変化させた場合のそれぞれについて，索引有無の実行時間を比較する．

4. (主索引と二次索引) 主索引と二次索引の性能の違いについて調査する．

なお、本課題に関連して[索引利用による性能変化](https://www.db.soc.i.kyoto-u.ac.jp/lec/le4db/index.php?%E7%B4%A2%E5%BC%95%E5%88%A9%E7%94%A8%E3%81%AB%E3%82%88%E3%82%8B%E6%80%A7%E8%83%BD%E5%A4%89%E5%8C%96)に参考情報があります。

## 1. キャッシュ

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create table users as
  select
    id,
    substring(md5(random()::text) from 1 for 6) as name,
    (random() * 100)::int as age
  from generate_series(1, 1000000) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users');

 pg_relation_size
------------------
         44285952
```

### キャッシュが有効になる質問

83歳未満のユーザー一覧を考えます

#### 1回目

```sql
# explain analyze select * from users where age < 83 limit 10;
                                                   QUERY PLAN
----------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.00..0.22 rows=10 width=15) (actual time=0.271..0.275 rows=10 loops=1)
   ->  Seq Scan on users  (cost=0.00..17906.00 rows=824248 width=15) (actual time=0.270..0.271 rows=10 loops=1)
         Filter: (age < 83)
         Rows Removed by Filter: 1
 Total runtime: 0.667 ms
(5 rows)
```

#### 2回目

```sql
# explain analyze select * from users where age < 83 limit 10;
                                                   QUERY PLAN
----------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.00..0.22 rows=10 width=15) (actual time=0.013..0.017 rows=10 loops=1)
   ->  Seq Scan on users  (cost=0.00..17906.00 rows=824248 width=15) (actual time=0.012..0.015 rows=10 loops=1)
         Filter: (age < 83)
         Rows Removed by Filter: 1
 Total runtime: 0.044 ms
(5 rows)
```

#### 3回目

```sql
# explain analyze select * from users where age < 83 limit 10;
                                                   QUERY PLAN
----------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.00..0.22 rows=10 width=15) (actual time=0.013..0.017 rows=10 loops=1)
   ->  Seq Scan on users  (cost=0.00..17906.00 rows=824248 width=15) (actual time=0.011..0.013 rows=10 loops=1)
         Filter: (age < 83)
         Rows Removed by Filter: 1
 Total runtime: 0.047 ms
(5 rows)
```

キャッシュが有効になったことで、actual time, total runtimeともに減少している。

### キャッシュが効きにくい質問

2000年1月1日以降に生まれたユーザー一覧

#### 1回目

```sql
# explain analyze select * from users where now() > (age * interval '1' year) + DATE '2000-1-1';
                                                   QUERY PLAN
----------------------------------------------------------------------------------------------------------------
 Seq Scan on users  (cost=0.00..27906.00 rows=333333 width=15) (actual time=0.051..329.909 rows=144746 loops=1)
   Filter: (now() > ('2000-01-01'::date + ((age)::double precision * '1 year'::interval year)))
   Rows Removed by Filter: 855254
 Total runtime: 337.127 ms
(4 rows)
```

#### 2回目

```sql
# explain analyze select * from users where now() > (age * interval '1' year) + DATE '2000-1-1';
                                                   QUERY PLAN
----------------------------------------------------------------------------------------------------------------
 Seq Scan on users  (cost=0.00..27906.00 rows=333333 width=15) (actual time=0.056..341.885 rows=144746 loops=1)
   Filter: (now() > ('2000-01-01'::date + ((age)::double precision * '1 year'::interval year)))
   Rows Removed by Filter: 855254
 Total runtime: 349.276 ms
(4 rows)
```

関数now()を使用している影響で、キャッシュが適用されず実行時間は毎回異なる

## 2. 索引の有無

### パターン1 (組数: 10, 属性数: 3, 索引をつける属性: id(int))

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create table users2_1 as
  select
    id,
    substring(md5(random()::text) from 1 for 6) as name,
    (random() * 100)::int as age
  from generate_series(1, 10) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users2_1');

 pg_relation_size
------------------
             8192
```

#### 索引がついていない場合

```sql
# explain analyze select * from users2_1 where id = 10;
                                             QUERY PLAN
----------------------------------------------------------------------------------------------------
 Seq Scan on users2_1  (cost=0.00..24.50 rows=6 width=40) (actual time=0.007..0.007 rows=1 loops=1)
   Filter: (id = 10)
   Rows Removed by Filter: 9
 Total runtime: 0.018 ms
(4 rows)
```

#### 索引がついている場合

```sql
create index id_index on users2_1 (id);
```

```sql
# explain analyze select * from users2_1 where id = 10;
                                            QUERY PLAN
---------------------------------------------------------------------------------------------------
 Seq Scan on users2_1  (cost=0.00..1.12 rows=1 width=40) (actual time=0.006..0.006 rows=1 loops=1)
   Filter: (id = 10)
   Rows Removed by Filter: 9
 Total runtime: 0.018 ms
(4 rows)
```

### パターン2 (組数: 1000000, 属性数: 3, 索引をつける属性: id(int))

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create table users2_2 as
  select
    id,
    substring(md5(random()::text) from 1 for 6) as name,
    (random() * 100)::int as age
  from generate_series(1, 1000000) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users2_2');

 pg_relation_size
------------------
         44285952
```

#### 索引がついていない場合

```sql
# explain analyze select * from users2_2 where id = 10;
                                               QUERY PLAN
--------------------------------------------------------------------------------------------------------
 Seq Scan on users2_2  (cost=0.00..17906.00 rows=1 width=15) (actual time=0.042..84.202 rows=1 loops=1)
   Filter: (id = 10)
   Rows Removed by Filter: 999999
 Total runtime: 84.221 ms
(4 rows)
```

#### 索引がついている場合

```sql
create index id_index_2_2 on users2_2 (id);
```

```sql
# explain analyze select * from users2_2 where id = 10;
                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Index Scan using id_index_2_2 on users2_2  (cost=0.42..8.44 rows=1 width=15) (actual time=0.037..0.037 rows=1 loops=1)
   Index Cond: (id = 10)
 Total runtime: 0.048 ms
(3 rows)
```

### パターン3 (組数: 1000000, 属性数: 20, 索引をつける属性: id(int))

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create table users2_3 as
  select
    id,
    substring(md5(random()::text) from 1 for 6) as name,
    (random() * 100)::int as age1,
    (random() * 100)::int as age2,
    (random() * 100)::int as age3,
    (random() * 100)::int as age4,
    (random() * 100)::int as age5,
    (random() * 100)::int as age6,
    (random() * 100)::int as age7,
    (random() * 100)::int as age8,
    (random() * 100)::int as age9,
    (random() * 100)::int as age10,
    (random() * 100)::int as age11,
    (random() * 100)::int as age12,
    (random() * 100)::int as age13,
    (random() * 100)::int as age14,
    (random() * 100)::int as age15,
    (random() * 100)::int as age16,
    (random() * 100)::int as age17,
    (random() * 100)::int as age18
  from generate_series(1, 1000000) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users2_3');

 pg_relation_size
------------------
        117030912
```

#### 索引がついていない場合

```sql
# explain analyze select * from users2_3 where id = 10;
                                                 QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Seq Scan on users2_3  (cost=0.00..24821.93 rows=4214 width=108) (actual time=0.041..152.508 rows=1 loops=1)
   Filter: (id = 10)
   Rows Removed by Filter: 999999
 Total runtime: 152.529 ms
(4 rows)
```

#### 索引がついている場合

```sql
create index id_index_2_3 on users2_3 (id);
```

```sql
# explain analyze select * from users2_3 where id = 10;
                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Index Scan using id_index_2_3 on users2_3  (cost=0.42..8.44 rows=1 width=83) (actual time=0.058..0.059 rows=1 loops=1)
   Index Cond: (id = 10)
 Total runtime: 0.081 ms
(3 rows)
```

### パターン4 (組数: 1000000, 属性数: 3, 索引をつける属性: name(text))

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create extension pgcrypto;
create table users2_4 as
  select
    id,
    encode(digest(random()::text, 'sha512'), 'hex')::text as name,
    (random() * 100)::int as age
  from generate_series(1, 1000000) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users2_4');

 pg_relation_size
------------------
        174301184
```

#### 索引がついていない場合

```sql
# explain analyze select * from users2_4 where name = '0bc403ae600b5ac01ed5301527a71b53e98063efb24781eaf0b29c7ebdc43a2fe2f798e2db3f4038998697fc8fc0db310127f7ddcf5a3331e7f1ea8a2487e4bd';
                                                                         QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
 Seq Scan on users2_4  (cost=0.00..52128.65 rows=12341 width=40) (actual time=80.608..152.726 rows=1 loops=1)
   Filter: (name = '0bc403ae600b5ac01ed5301527a71b53e98063efb24781eaf0b29c7ebdc43a2fe2f798e2db3f4038998697fc8fc0db310127f7ddcf5a3331e7f1ea8a2487e4bd'::text)
   Rows Removed by Filter: 999999
 Total runtime: 152.741 ms
(4 rows)
```

#### 索引がついている場合

```sql
create index name_index_2_4 on users2_4 (name);
```

```sql
# explain analyze select * from users2_4 where name = '0bc403ae600b5ac01ed5301527a71b53e98063efb24781eaf0b29c7ebdc43a2fe2f798e2db3f4038998697fc8fc0db310127f7ddcf5a3331e7f1ea8a2487e4bd';
                                                                              QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on users2_4  (cost=459.30..12264.99 rows=5000 width=40) (actual time=0.085..0.086 rows=1 loops=1)
   Recheck Cond: (name = '0bc403ae600b5ac01ed5301527a71b53e98063efb24781eaf0b29c7ebdc43a2fe2f798e2db3f4038998697fc8fc0db310127f7ddcf5a3331e7f1ea8a2487e4bd'::text)
   ->  Bitmap Index Scan on name_index_2_4  (cost=0.00..458.05 rows=5000 width=0) (actual time=0.078..0.078 rows=1 loops=1)
         Index Cond: (name = '0bc403ae600b5ac01ed5301527a71b53e98063efb24781eaf0b29c7ebdc43a2fe2f798e2db3f4038998697fc8fc0db310127f7ddcf5a3331e7f1ea8a2487e4bd'::text)
 Total runtime: 0.101 ms
(5 rows)
```

### 考察

組数が少ない場合(パターン1)、選択質問に対して索引は使用されなかったため、検索時間は変わらなかった。

組数が多く、属性数が少なく、組の大きさが小さい場合(パターン2)、索引がついている場合はIndex Scanが実行され、検索時間が短縮された。

組数と属性数が多く、組の大きさが小さい場合(パターン3)、索引がついている場合はIndex Scanが実行され、検索時間が短縮された。

組数が多く、属性数が少なく、組の大きさが大きい場合(パターン4)、索引がついている場合はBitmap Heap Scan, Bitmap Index Scanが実行され、検索時間が短縮された。

組数が多い場合、索引が効果的に働くことがわかった。

また、組の大きさが大きい場合は索引は働くが、組の大きさが小さい場合よりも検索時間が伸びることがわかった。

## 3. 選択率

### 選択率が小さい場合 (選択率: 1/1000000)

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create table users3_1 as
  select
    id,
    substring(md5(random()::text) from 1 for 6) as name,
    (random() * 100)::int as age
  from generate_series(1, 1000000) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users3_1');

 pg_relation_size
------------------
         44285952
```

#### 索引がついていない場合

```sql
# explain analyze select * from users3_1 where id = 500000;
                                                 QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Seq Scan on users3_1  (cost=0.00..13244.70 rows=3135 width=40) (actual time=88.545..149.349 rows=1 loops=1)
   Filter: (id = 500000)
   Rows Removed by Filter: 999999
 Total runtime: 149.367 ms
(4 rows)
```

#### 索引がついている場合

```sql
create index id_index_3_1 on users3_1 (id);
```

```sql
# explain analyze select * from users3_1 where id = 500000;
                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Index Scan using id_index_3_1 on users3_1  (cost=0.42..8.44 rows=1 width=15) (actual time=0.053..0.054 rows=1 loops=1)
   Index Cond: (id = 500000)
 Total runtime: 0.072 ms
(3 rows)
```

### 選択率が大きい場合 (選択率: 1/2)

ダミーデータを作成するため、以下の様にテーブルを作成し、データを格納します

```sql
create table users3_2 as
  select
    id,
    substring(md5(random()::text) from 1 for 6) as name,
    (random() * 2)::int as age
  from generate_series(1, 1000000) as id;
```

サイズは以下のようになりました

```sql
# select pg_relation_size('users3_2');

 pg_relation_size
------------------
         44285952
```

#### 索引がついていない場合

```sql
# explain analyze select * from users3_2 where age = 0;
                                                   QUERY PLAN
-----------------------------------------------------------------------------------------------------------------
 Seq Scan on users3_2  (cost=0.00..13244.70 rows=3135 width=40) (actual time=0.009..163.648 rows=249689 loops=1)
   Filter: (age = 0)
   Rows Removed by Filter: 750311
 Total runtime: 177.433 ms
(4 rows)
```

#### 索引がついている場合

```sql
create index age_index_3_2 on users3_2 (age);
```

```sql
# explain analyze select * from users3_2 where age = 0;
                                                             QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on users3_2  (cost=4610.41..13090.57 rows=245933 width=15) (actual time=26.184..80.495 rows=249689 loops=1)
   Recheck Cond: (age = 0)
   ->  Bitmap Index Scan on age_index_3_2  (cost=0.00..4548.92 rows=245933 width=0) (actual time=24.458..24.458 rows=249689 loops=1)
         Index Cond: (age = 0)
 Total runtime: 93.440 ms
(5 rows)
```

### 考察

選択率が高い場合、選択率が低い場合と比べて索引による効果が小さくなった。

また、選択率が低い場合はIndex Scanが使用されたが、選択率が高い場合はBitmap Heap Scanが使用された。

## 4. 主索引と二次索引
