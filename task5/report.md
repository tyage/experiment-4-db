# 課題５

- 工学部情報学科3回
- {student-name}
- {student-id}

質問および更新を実行するSQL文を作成する．

上記で構築したデータベースに対して，以下の各内容のSQL文を作成して，実行してください．

レポートでは，各項目について，SQL文，その説明および実行結果を示しなさい．

また，各SQL文は可能な限り実用的に意味があるものにするようにしてください．

注意：各SQL文は実際に利用される状況を考慮し，現実的に利用可能であるよう心がけること．

1. 関係代数の射影および選択に対応するSQL文
2. 関係代数の自然結合に対応するSQL文
3. UNIONを含むSQL文
4. EXCEPTを含むSQL文
5. DISTINCTを含むSQL文
6. 集合関数(COUNT,SUM,AVG,MAX,MIN)を用いたSQL文
7. 副質問(sub query)を含むSQL文
8. UPDATEを含むSQL文
9. ORDRE BYを含むSQL文
10. Create Viewを含むSQL文

## 1. 関係代数の射影および選択に対応するSQL文

購入者のid一覧を取得

```sql
select id from buyer;
```

```
1
```

# 2. 関係代数の自然結合に対応するSQL文

商品と販売者テーブルを自然結合

```sql
select * from product natural left join seller;
```

```
1|1|鮭の切り身|100||
2|1|鮭のムニエル|200||
3|1|鮭のおにぎり|100||
```

# 3. UNIONを含むSQL文

販売者と購入者の一覧を取得

```sql
select * from buyer union all select * from seller;
```

```
1|example@example.com|test|*****
1|seller1@example.com|seller1|********
```

# 4. EXCEPTを含むSQL文

idが1番の商品以外を取得

```sql
select * from product except select * from product where id = 1;
```

```
2|1|鮭のムニエル|200
3|1|鮭のおにぎり|100
```

# 5. DISTINCTを含むSQL文

商品名一覧を重複を除いて取得

```sql
select distinct name from product;
```

```
鮭の切り身
鮭のムニエル
鮭のおにぎり
```

# 6. 集合関数(COUNT,SUM,AVG,MAX,MIN)を用いたSQL文

## COUNT

購入ユーザー数を取得

```sql
select count(*) from buyer;
```

```
1
```

## SUM

商品の金額の合計を取得

```sql
select sum(cost) from product;
```

```
400
```

## AVG

商品の平均金額を取得

```sql
select avg(cost) from product;
```

```
133.333333333333
```

## MAX

最高値の商品の値段を取得

```sql
select max(cost) from product;
```

```
200
```

## MIN

最安値の商品の値段を取得

```sql
select min(cost) from product;
```

```
100
```

# 7. 副質問(sub query)を含むSQL文

最安値の商品一覧を表示

```sql
select * from product where cost = (select min(cost) from product);
```

```
1|1|鮭の切り身|100
3|1|鮭のおにぎり|100
```

# 8. UPDATEを含むSQL文

idが1の販売者のパスワードを更新

```sql
update seller set password = '***' where id = 1;
```

# 9. ORDER BYを含むSQL文

商品一覧を値段で降順にソートして取得

```sql
select * from product order by cost desc;
```

```
2|1|鮭のムニエル|200
1|1|鮭の切り身|100
3|1|鮭のおにぎり|100
```

# 10. Create Viewを含むSQL文

販売者、購入者ユーザテーブルを結合したuser viewを作成し、一覧を取得する

```sql
create view user as select * from seller union all select * from buyer;
select * from user;
```

```
1|seller1@example.com|seller1|***
1|example@example.com|test|*****
```
