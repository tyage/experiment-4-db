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

## 3. 選択率

## 4. 主索引と二次索引
